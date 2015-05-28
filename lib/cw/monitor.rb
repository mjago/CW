# encoding: utf-8

# class Monitor

class monitor

  attr_accessor :quit

  def initialize cw
    @cw = cw
  end

  def cw
    @cw
  end

  def monitor_keys
    str = '  '
    chr = ''
    loop do
      begin
        system("stty raw -echo")
        chr = STDIN.getc
        #input_file.print chr
        str[0] = str[1]
        str[1] = chr
        quit = true if str == 'qq'
        @entered_word << chr
        check_match
      ensure
        system("stty -raw echo")
      end
      break if @quit == true
    end
  end
end
