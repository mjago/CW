# encoding: utf-8

class KeyInput

  def initialize
    @quit_ary = Array.new(4)
  end

  def char
    @chr
  end

  def read
    @chr = nil
    begin
      system("stty raw -echo")
      @chr = STDIN.getc
    ensure
      system("stty raw -echo")
    end
  end

  def is_letter?
    @chr >= 'a' && @chr <= 'z'
  end

  def is_number?
    @chr >= '0' && @chr <= '9'
  end

  def is_punctuation?
    [' ', ',', '.', '=', '?'].detect{|letr| letr == @chr}
  end

  def is_relevant_char?
    is_letter? || is_number? || is_punctuation? ? true : false
  end

  def reset_stdin
    system("stty -raw echo")
  end

  def quit_input?
    @quit_ary.rotate!
    @quit_ary[3] = @chr
    quit_str = @quit_ary.join.downcase
    if quit_str == 'qqqq'
      reset_stdin
      return true
    end
  end

end
