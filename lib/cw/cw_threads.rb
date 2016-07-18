# encoding: utf-8

class CWThreads

  attr_reader :threads

  def initialize context, processes
    @context = context
    @processes = processes
  end

  def start_threads
    @threads = @processes.collect do |th|
      {:thread =>
       Thread.new do
         @context.send th
       end,
       :name => th
      }
    end
  end

  def monitor_threads
    exiting = false
    loop do
      sleep 0.5
      @threads.each do |th|
        if thread_false_or_nil?(th)
          exiting = true
          unless Params.exit
            print "\r"
            puts "** #{th[:name].to_s.gsub('_',' ')} quit unexpectedly!**"
            if th[:thread].backtrace
              STDERR.puts th[:thread].backtrace.join("\n    \\_ ")
            end
          end
        end
      end
      # print_threads_status
      exiting = true if(Params.exit)
      break if exiting
    end
    close_threads if exiting
  end

  def kill_thread thread
    thread[:thread].kill
  end

  def kill_open_threads
    @threads.each do |thread|
      unless thread_false_or_nil?(thread)
        kill_thread thread
      end
    end
  end

  def thread_false_or_nil? th
    if(th[:thread].status == false)
      return true
    end

    if(th[:thread].nil?)
      return true
    end
  end

  def print_threads_status
    @threads.each do |thread|
      puts "\r"
      print "#{thread[:name]} = #{thread[:thread].status} "
    end
  end

  def kill_monitor_keys_thread_maybe thread
    kill_thread(thread) unless thread_false_or_nil?(thread)
  end

  def close_threads
    await_termination_count = 0

    loop do
      waiting = false
      sleep 0.1
      @threads.each do |thread|
        if(thread[:name] == :monitor_keys_thread)
          kill_monitor_keys_thread_maybe thread
        else
          unless thread_false_or_nil?(thread)
            waiting = true
            break
          end
        end
      end
      # print_threads_status
      return if(waiting == false)
      await_termination_count += 1
      break if(await_termination_count >= 10)
    end

    kill_open_threads
    # print_threads_status
    system("stty -raw echo")
    sleep 0.2
    exit(1)
  end

  def run
    start_threads
    monitor_threads
    system("stty -raw echo")
  end

end
