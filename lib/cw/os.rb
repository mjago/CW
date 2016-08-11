require 'os'

module CWG
  module OStest
    def is_mac?
      OS.mac?
    end

    def is_posix?
      OS.posix?
    end
  end
end
