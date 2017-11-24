# encoding: utf-8

module CWG

  class Threads

    attr_reader :threads

    def initialize context, processes
      Thread.abort_on_exception = true
      @context = context
      @processes = processes
      @threads = []
    end

    def start_threads
      @processes.collect do |th|
        @threads << start_thread(@context, th)
      end
    end

    def start_thread context, th
      {
        :thread => Thread.new do
          context.send th
        end,
        :name => th
      }
    end

    def kill_thread thread
      thread[:thread].kill
    end

    def kill_thread_x x
      @threads.each_with_index do |th,idx|
        if th[:name] == x
          kill_thread th
          @threads.delete_at idx
        end
      end
    end

    def join x
      @threads.each do |th|
        if th[:name] == x
          th[:thread].join
        end
      end
    end

    def add context, th
      @threads << start_thread(context, th)
    end

    def monitor_threads
      exiting = false
      loop do
        sleep 0.5
#        @threads.each do |th|
#          if thread_false_or_nil?(th)
##todo            exiting = true
#            unless Cfg.config["exit"]
##              puts "** #{th[:name].to_s.gsub('_',' ')} quit unexpectedly!**"
#              if th[:thread].backtrace
#                STDERR.puts th[:thread].backtrace.join("\n    \\_ ")
#              end
#            end
#          end
        # print_threads_status
        exiting = true if(Cfg.config["exit"])
        break if exiting
      end
      @threads.each do |th|
        th[:thread].kill.join
      end
      #close_threads if exiting
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

      if(th[:thread].status.nil?)
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
        print "#{thread[:name]} = "
        #        p thread[:thread].status
      end
    end

    def kill_monitor_keys_thread_maybe thread
      kill_thread(thread) unless thread_false_or_nil?(thread)
    end

    def any_thread_open?
      @threads.each do |thread|
#        print "status "
#            p thread
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
      puts "exiting"
#      puts "Forcing kill!\r"
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
#         print_threads_status
        await_termination_count += 1
        force_kill if(await_termination_count >= 30)
      end
    end

    def run
      start_threads
      monitor_threads
      system("stty -raw echo")
      puts "\r"
    end

  end

end
