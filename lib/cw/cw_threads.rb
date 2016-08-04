# encoding: utf-8

module CWG

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
            unless Cfg.config["exit"]
              print "\r"
              puts "** #{th[:name].to_s.gsub('_',' ')} quit unexpectedly!**"
              if th[:thread].backtrace
                STDERR.puts th[:thread].backtrace.join("\n    \\_ ")
              end
            end
          end
        end
        # print_threads_status
        exiting = true if(Cfg.config["exit"])
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

    def wait_for_threads
      Cfg.config.params["exit"] = false
      loop do
        alive = false
        sleep 0.1
        @threads.each { |th|
          if  thread_false_or_nil? th
          elsif th[:name] != :monitor_keys_thread
            alive = true
          end
        }
        break unless alive
      end
      threads.each {|th|
        if(th[:name] == :monitor_keys_thread)
          kill_thread th
        end
        sleep 0.1
      }
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

    def any_thread_open?
      @threads.each do |thread|
        if(thread[:name] == :monitor_keys_thread)
          kill_monitor_keys_thread_maybe thread
        else
          unless thread_false_or_nil?(thread)
            return true
          end
        end
      end
      nil
    end

    def force_kill
      puts 'Forcing kill!'
      kill_open_threads
      # print_threads_status
      system("stty -raw echo")
      sleep 0.2
      exit(1)
    end

    def close_threads
      await_termination_count = 0
      loop do
        sleep 0.1
        break unless any_thread_open?()
        # print_threads_status
        await_termination_count += 1
        force_kill if(await_termination_count >= 10)
      end
    end

    def run
      start_threads
      monitor_threads
      system("stty -raw echo")
    end

  end

end
