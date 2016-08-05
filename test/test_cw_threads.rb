require 'simplecov'
$VERBOSE = nil #FIXME
#SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw/cw_threads.rb'

class TestCWStream < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../../'

  def a_thread
    @test_var = 2 + 3
  end

  def sleep_thread
    sleep 100
  end

  def setup
    @test_var = 0
    @threads = CWG::CWThreads.new(self, [:a_thread])
  end

  def teardown
    @cw = nil
  end

  def test_cw_threads
    assert true
  end

  def test_threads_exposes_name
    @threads.start_threads
    assert_equal :a_thread, (@threads.threads)[0][:name]
  end

  def test_threads_exposes_thread
    @threads.start_threads
    assert @threads.threads[0][:thread].is_a? Thread
  end

  def test_start_threads_runs_thread
    @threads.start_threads
    sleep 0.1
    assert_equal 5, @test_var
  end

# failed on one build
#  def test_kill_thread_kills_thread
#    threads = CWG::CWThreads.new(self, [:sleep_thread])
#    threads.start_threads
#    thread = threads.threads[0]
#    assert_equal "run", thread[:thread].status
#    threads.kill_thread thread
#    count = 0
#    status = ''
#    loop do
#      status = thread[:thread].status
#      break unless status
#      sleep 0.01
#      count += 1
#      break if(count >= 10)
#    end
#
#    assert(count < 10)
#  end
#
  def test_handles_multiple_threads
    threads = CWG::CWThreads.new(self, [:a_thread, :sleep_thread])
    threads.start_threads
    assert threads.threads[0][:thread].is_a? Thread
    assert threads.threads[1][:thread].is_a? Thread
    assert_nil threads.threads[2]
  end

# failed on one build
#  def test_thread_false_or_nil_returns_true_and_false
#    @threads.start_threads
#    thread = @threads.threads[0]
#    refute @threads.thread_false_or_nil?(@threads.threads[0])
#    @threads.kill_thread thread
#    count = 0
#    status = ''
#    loop do
#      status = thread[:thread].status
#      break unless status
#      sleep 0.01
#      count += 1
#      break if(count >= 10)
#    end
#    assert count < 10
#    assert @threads.thread_false_or_nil?(@threads.threads[0])
#  end

#todo  Too fragile!
#  def test_kill_open_threads_kills_threads
#    threads = CWThreads.new(self, [:sleep_thread, :a_thread])
#    threads.start_threads
#    thread0 = threads.threads[0]
#    assert_equal "run", thread0[:thread].status
#    thread1 = threads.threads[1]
#    assert_equal "run", thread1[:thread].status
#    threads.kill_open_threads
#    count = 0
#    found = 0
#    loop do
#      found = 0
#      [thread0, thread1].each do |thr|
#        found += 1 if thr[:thread].status == false
#      end
#      break if(found == 2)
#      count += 1
#      puts count
#      break if count > 10
#      sleep 0.01
#    end
#    assert(count < 10)
#    assert_equal 2, found
#  end

end
