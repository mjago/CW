# encoding: utf-8

class CWThreads

  attr_accessor :threads

  def initialize context, processes
    @context = context
    @processes = processes
  end

  def kill
    sleep 0.2
    if @threads.is_a?(Array)
      @threads.each do |th|
        th.exit if th.is_a? Thread
      end
    end
  end

  def start_threads
    @threads = @processes.collect do |th|
      {:thread =>
       Thread.new do
         p th
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
        if (th[:thread].status == nil) || (th[:thread].status == false)
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
      break if exiting
    end
    if exiting
      count = 0
      loop do
#        puts 'exiting'
        th0 = @threads[0][:thread].status
        th1 = @threads[1][:thread].status
        th2 = @threads[2][:thread].status
#        puts "\r"
#        puts "#{@threads[0][:name]} = #{th0}\r"
#        puts "#{@threads[1][:name]} = #{th1}\r"
#        puts "#{@threads[2][:name]} = #{th2}\r"

        finished_count = 0
        @threads.each do |th|
          unless(th[:thread].status == nil) || (th[:thread].status == false)
#            puts "killing #{th[:name]}"
            th[:thread].kill
          end
        end
        #            puts "\r"
        #            if((th1 == false || th1 == nil) &&
        #               (th2 == false || th2 == nil))
        #              Params.exit = true
        #              puts "@threads[0].exit"
        sleep 0.1
        #              puts "killing #{@threads[0][:name]}"
        #              puts "@threads[0].exit"
        if((th0 == false || th0 == nil) &&
           (th1 == false || th1 == nil) &&
           (th2 == false || th2 == nil))

#          puts 'exiting'
          system("stty -raw echo")
          sleep 0.2
          exit(0)
          break
        end
        sleep 0.2
      end
      sleep 0.5
      count += 1
#      puts "count = #{count}"
      exit(0) if count >= 10
    end
  end

  def wait_for_threads
    @threads.each { |th| th.join }
  end

  def run
    start_threads
    monitor_threads
    #todo    wait_for_threads
  end

end
