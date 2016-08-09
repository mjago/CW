# encoding: utf-8

module CWG

  class Timing

    attr_accessor :delay_time
    attr_accessor :start_time

    def initialize
      @delay_time = 0.0
      @cw_encoding = CwEncoding.new
    end

    def cw_encoding enc
      @cw_encoding.fetch(enc)
    end

    def dot wpm
      1.2 / wpm.to_f
    end

    def dot_ms
      dot @wpm
    end

    def init_print_words_timeout
      @start_print_time, @delay_print_time = Time.now, 2.0
    end

    def print_words_timeout?
      (Time.now - @start_print_time) > @delay_print_time
    end

    def effective_dot_ms
      dot @effective_wpm
    end

    def init_char_timer
      @start_time, @delay_time = Time.now, 0.0
    end

    def char_delay_timeout?
      (Time.now - @start_time) > @delay_time
    end

    def char_timing(* args)
      timing = 0
      args.flatten.each do |arg|
        case arg
        when :dot  then timing += 2
        when :dash then timing += 4
        else
          puts "Error! invalid morse symbol - was #{arg}"
        end
      end
      timing -= 1
      timing = timing.to_f * dot_ms
      timing + code_space_timing
    end

    def code_space_timing
      @effective_wpm ? 3.0 * effective_dot_ms :
        3.0 * dot_ms
    end

    def space_timing
      space = 4.0
      @effective_wpm ? space * effective_dot_ms :
        space * dot_ms
    end

    def char_delay(char, wpm, ewpm)
      @wpm, @effective_wpm = wpm, ewpm
      if(char != ' ')
        char_timing(cw_encoding(char)) unless(char == ' ')
      else
        space_timing
      end
    end

    def append_char_delay letr, wpm, ewpm
      @delay_time += char_delay(letr, wpm, ewpm)
    end

  end

end
