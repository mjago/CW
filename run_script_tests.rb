require 'sequel'

def populate_cw_scripts ds
  scripts = (Dir.glob('/Users/martyn/jekyll/documentation-theme-jekyll/cw_scripts/*.rb'))
  scripts.each do |script|
    script_name = File.basename(script,'.rb')
    # populate the table
    ds.insert(:script => "#{script_name}",
              :path => '/Users/martyn/jekyll/documentation-theme-jekyll/cw_scripts')
  end
end

def use_in_memory_database
#  db = Sequel.sqlite('test.sqlite')
  db = Sequel.sqlite
  db.create_table :scripts do
    primary_key :id
    String :script, :null => false
    String :path, :null => false
  end

  db.create_table :test_runs do
    primary_key :id
    DateTime :date_time
    Fixnum :total_secs
    String :result
  end

  db.create_table :tests do
    primary_key :id
    Fixnum :test_run_id, :null => false
    Fixnum :script_id, :null => false
    Fixnum :wpm, :null => false
    Fixnum :ewpm, :null => false
    String :duration
  end

  db.create_table :test_run do
    primary_key :id
    Fixnum :script_id, :unique => true, :null => false
    String :duration
    TimeDate :time_date
  end
  db
end

def rewrite_sentence_count
  File.open("data/text/progress.txt",'w') do |f|
    f.puts "0"
  end
end

db  = Sequel.sqlite('test.sqlite')
#db = use_in_memory_database

ds_scripts   = db[:scripts]
ds_test_runs = db[:test_runs]
ds_tests     = db[:tests]

#populate_cw_scripts ds_scripts

total_start_time = Time.now
finish_time = Time.new

test_run_id = ds_test_runs.insert(:date_time => Time.now,
                                  :total_secs => 0,
                                  :result    => "fail")
ds_scripts.each do |test|
  filename = File.join test[:path], test[:script] + '.rb'
  rewrite_sentence_count if test[:script].include?("book_reading")
  puts "Running: #{test[:script]}"
  start_time = Time.now
  next if test[:script].include? ("five_common_words_4") # repeat_word
  system("CW_ENV=test bundle exec ruby #{filename}")
  finish_time = Time.now
  ds_tests.insert(:script_id   => test[:id],
                  :test_run_id => test_run_id,
                  :wpm         => 60,
                  :ewpm        => 60,
                  :duration    => "#{finish_time - start_time}")
  puts
end

rec = db[:test_runs].where(:id => test_run_id)
rec.update(:total_secs=>finish_time - total_start_time, :result=>"pass")
puts ds_test_runs.all
