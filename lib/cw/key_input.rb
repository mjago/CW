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
        @chr = @chr.downcase unless(@chr.include? 'Q')
        #        puts "@chr = #{@chr}"
        @chr
      ensure
        system("stty raw -echo")
      end
    end

    def is_letter? char = nil
      char = char ? char : @chr
      char >= 'a' && char <= 'z'
    end

    def is_number? char = nil
      char = char ? char : @chr
      char >= '0' && char <= '9'
    end

    def is_punctuation? char = nil
      char = char ? char : @chr
      [' ', ',', '.', '=', '?','/','+'].detect{|letr| letr == char}
    end

    def is_relevant_char? char = nil
      char = char ? char : @chr
      is_letter?(char) || is_number?(char) || is_punctuation?(char) ? true : false
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
      Cfg.config.params["exit"] = true
      reset_stdin
      return true
    end

    def quit_input?
      push_to_quit_maybe
      return quit if is_quit?
    end

  end

end
