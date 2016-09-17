require 'rubyserial'

module CWG

  class Winkey

    def initialize
      STDERR.puts "Attempting to open winkey connection"
      port_str = "/dev/cu.usbserial-AD01XY9H"  #may be different for you
      baud_rate = 1200
      data_bits = 8
      begin
        @serial = Serial.new(port_str, baud_rate, data_bits)
        @serial.closed?
      rescue => e
        p e
        p @serial
        STDERR.puts "Failed to open serial port - Exiting!"
        exit 1
      end
    end

    def write data
      @serial.write data
    end

    def getbyte
      @serial.getbyte
    end

    def close
      puts 'Closing'
      @serial.close
    end
  end
end
