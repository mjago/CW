module Process
  def exist?(pid)
    Process.kill(0, pid)
    true
  rescue Errno::ESRCH
    false
  end
  module_function :exist?
end
