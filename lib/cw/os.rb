require 'os'

module CW
  module OStest
    def is_mac?
      OS.mac?
    end

    def is_posix?
      OS.posix?
    end
  end
end
