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
      Thread.new{@context.send th}
    end
  end

  def wait_for_threads
    @threads.each { |th| th.join }
  end

  def run
    start_threads
    wait_for_threads
  end

end
