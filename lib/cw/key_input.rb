# encoding: utf-8

module CWG

class KeyInput

  def initialize
    @quit_count = 0
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


  def push_to_quit_maybe
    if @chr == 'q'
      @quit_count += 1
    else
      @quit_count = 0
    end
  end

  def is_quit?
    @quit_count >= 4
  end

  def quit
    Params.exit = true
    reset_stdin
    return true
  end

  def quit_input?
    push_to_quit_maybe
    return quit if is_quit?
  end

end

end
