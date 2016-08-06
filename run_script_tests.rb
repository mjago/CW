require 'sequel'

DEBUG = false

class RunScriptTests
  TEST_ON_MEMORY_DATABASE = false unless(DEBUG)
  TEST_ON_MEMORY_DATABASE = true if(DEBUG)
  NO_RSS_FEED = false unless(DEBUG)
  NO_RSS_FEED = true if(DEBUG)
  PATH_TO_CW_SCRIPTS = '/Users/martyn/jekyll/documentation-theme-jekyll/cw_scripts'
  PROGRESS_FILE = "data/text/progress.txt"
  DB = Sequel.sqlite('test.sqlite')  unless(TEST_ON_MEMORY_DATABASE)
  DB = Sequel.sqlite if(TEST_ON_MEMORY_DATABASE)

  def initialize
    create_tables if(TEST_ON_MEMORY_DATABASE)
    @ds = init_datasets
    populate_cw_scripts if(TEST_ON_MEMORY_DATABASE)
  end

  def create_tables
    DB.create_table :scripts do
      primary_key :id
      String :script, :null => false
      String :path, :null => false
    end

    DB.create_table :test_runs do
      primary_key :id
      DateTime :date_time
      Fixnum :total_secs
      String :result
    end

    DB.create_table :tests do
      primary_key :id
      Fixnum :test_run_id, :null => false
      Fixnum :script_id, :null => false
      Fixnum :wpm, :null => false
      Fixnum :ewpm, :null => false
      String :duration
    end
  end

  def init_datasets
    {
      scripts:   DB[:scripts],
      test_runs: DB[:test_runs],
      tests:     DB[:tests]
    }
  end

  def populate_cw_scripts
    scripts = (Dir.glob(PATH_TO_CW_SCRIPTS + '/*.rb'))
    scripts.each do |script|
      script_name = File.basename(script,'.rb')
      # populate the table
      @ds[:scripts].insert(:script => "#{script_name}",
                        :path => PATH_TO_CW_SCRIPTS)
    end
  end

  def reset_sentence_count
    File.open(PROGRESS_FILE,'w') do |f|
      f.puts "0"
    end
  end

  def get_current_test_runs(test_run_id)
    DB[:test_runs].where(:id => test_run_id)
  end

  def update_current_test_run(test_run_id,total_secs)
    current = get_current_test_runs(test_run_id)
    current.update(:total_secs=> total_secs, :result=>"pass")
  end

  def exec_command line
    system(line)
  end

  def set_test_environment
    "CW_ENV=test "
  end

  def run_test filename, environment = nil
    environment == :test ?
      env = set_test_environment : env = ''
    exec_command(env + "bundle exec ruby #{filename}")
  end

  def execute_test_env filename
    if DEBUG
      sleep 0.05
    else
      run_test(filename, :test)
    end
  end

  class Timer
    def initialize
      @finish_time = @total_start_time = Time.now
    end

    def start
      @start_time = Time.now
    end
    def finish
      @finish_time = Time.now
    end
    def duration
      @finish_time - @start_time
    end
    def total_secs
      @finish_time - @total_start_time
    end
    def running_time
      Time.now - @total_start_time
    end
  end

  def test_runs_insert_dateTime
    @ds[:test_runs].insert(:date_time => Time.now,
                           :total_secs => 0,
                           :result    => "fail")
  end

  def reset_sentence_count_maybe script_name
    if script_name.include?("book_reading")
      reset_sentence_count
    end
  end

  def print_last_five_results
    @ds[:test_runs].each do |test_run|
      if(test_run[:id] > (@test_run_id - 5))
        puts test_run[:date_time].to_s + ': ' +
             "Total secs: " + test_run[:total_secs].to_s
      end
    end
  end

  def run
    timer = Timer.new
    @test_run_id = test_runs_insert_dateTime
    @ds[:scripts].each do |test|
      filename = File.join test[:path], test[:script] + '.rb'
      puts "[#{timer.running_time.to_i}] Running: #{test[:script]}"
      reset_sentence_count_maybe test[:script]
      timer.start
#      next unless test[:script].include? ("book_reading")
      execute_test_env filename
      timer.finish
      reset_sentence_count_maybe test[:script]
      @ds[:tests].insert(:script_id    => test[:id],
                         :test_run_id  => @test_run_id,
                         :wpm          => 60,
                         :ewpm         => 60,
                         :duration     => "#{timer.duration}")
      @ds[:tests].all
    end
    update_current_test_run(@test_run_id,timer.total_secs)
#    puts @ds[:test_runs].all # if DEBUG
    run_test(PATH_TO_CW_SCRIPTS + '/rss_feed.rb') unless(NO_RSS_FEED)
    print_last_five_results
  end
end

test_scripts = RunScriptTests.new
10.times do |loop_count|
  puts "loop_count = #{loop_count}"
  test_scripts.run
  break unless(DEBUG)
end
