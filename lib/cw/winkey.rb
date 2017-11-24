require 'rubyserial'

module CW
  class Winkey

    def initialize
      @print = Print.new
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

    def check_status byte
      status = byte & 192
      if status == 192
#        puts "status"
        true
      elsif status == 128
#        puts "wpm"
        true
      else
#        puts "byte 0x#{byte.to_s()}"
        false
      end
    end

    def string str
#      puts str
      write str
      str.split('').each do |ip|
#        puts "ip = #{ip}"
        read ip.ord, "sent and received #{ip.chr}"
      end
    end

    def read match, match_msg
      loop_delay = 0.05
      count = 1
      25.times do
        byte = getbyte
        unless byte.nil?
          unless check_status(byte)
#            puts "count is, #{count}, byte is #{byte.inspect}, match is #{match.inspect}"
            if byte == match
#              print byte.ord
#              puts match_msg
              return
            end
          end
        end
        count += 1
        sleep loop_delay
      end
    end

    def command cmd
      {
        on: "\x00\x02",
        no_weighting: "\x03\x32",
        echo: "\x00\x04\x5A"
      }[cmd]
    end

    def on
      puts 'host on'
      write command :on
      read 23, "on ack"
    end

    def no_weighting
      puts 'no weighting'
      write command :no_weighting
    end

    def echo
      puts 'echo test'
      write command :echo
      read 'Z'.ord, "echo success"
    end

    def wpm wpm
      puts "set wpm to #{wpm}"
      write "\x02"
      write [wpm].pack('U')
    end

    def sent?
      true
    end

    def wait_while_sending
      until sent?
        sleep 0.01
      end
    end
  end
end
