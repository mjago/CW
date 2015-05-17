class Timing

  attr_accessor :delay_time
  attr_accessor :start_time

  def initialize
    @delay_time = 0.0
  end

  def dot wpm
    1.2 / wpm
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

  def init_play_words_timeout
    @start_play_time, @delay_play_time = Time.now, 2.0
  end

  def play_words_timeout?
    (Time.now - @start_play_time) > @delay_play_time
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
    args.each do |arg|
      case arg
      when :dit then timing += 2
      when :dah then timing += 4
      else
        puts "Error! invalid morse symbol"
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
    encoding = {
      'a' => char_timing(:dit, :dah),
      'b' => char_timing(:dah, :dit, :dit, :dit),
      'c' => char_timing(:dah, :dit, :dah, :dit),
      'd' => char_timing(:dah, :dit, :dit),
      'e' => char_timing(:dit),
      'f' => char_timing(:dit, :dit, :dah, :dit),
      'g' => char_timing(:dah, :dah, :dit),
      'h' => char_timing(:dit, :dit, :dit, :dit),
      'i' => char_timing(:dit, :dit),
      'j' => char_timing(:dit, :dah, :dah, :dah),
      'k' => char_timing(:dah, :dit, :dah),
      'l' => char_timing(:dit, :dah, :dit, :dit),
      'm' => char_timing(:dah, :dah),
      'n' => char_timing(:dah, :dit),
      'o' => char_timing(:dah, :dah, :dah),
      'p' => char_timing(:dit, :dah, :dah, :dit),
      'q' => char_timing(:dah, :dah, :dit, :dah),
      'r' => char_timing(:dit, :dah, :dit),
      's' => char_timing(:dit, :dit, :dit),
      't' => char_timing(:dah),
      'u' => char_timing(:dit, :dit, :dah),
      'v' => char_timing(:dit, :dit, :dit, :dah),
      'w' => char_timing(:dit, :dah, :dah),
      'x' => char_timing(:dah, :dit, :dit, :dah),
      'y' => char_timing(:dah, :dit, :dah, :dah),
      'z' => char_timing(:dah, :dah, :dit, :dit),
      '1' => char_timing(:dit, :dah, :dah, :dah, :dah),
      '2' => char_timing(:dit, :dit, :dah, :dah, :dah),
      '3' => char_timing(:dit, :dit, :dit, :dah, :dah),
      '4' => char_timing(:dit, :dit, :dit, :dit, :dah),
      '5' => char_timing(:dit, :dit, :dit, :dit, :dit),
      '6' => char_timing(:dah, :dit, :dit, :dit, :dit),
      '7' => char_timing(:dah, :dah, :dit, :dit, :dit),
      '8' => char_timing(:dah, :dah, :dah, :dit, :dit),
      '9' => char_timing(:dah, :dah, :dah, :dah, :dit),
      '0' => char_timing(:dah, :dah, :dah, :dah, :dah),
      '.' => char_timing(:dit, :dah, :dit, :dah, :dit, :dah),
      ',' => char_timing(:dah, :dah, :dit, :dit, :dah, :dah),
      ' ' => space_timing(),
      '=' => char_timing(:dah, :dit, :dit,:dit, :dah),
      '!' => char_timing(:dit, :dit, :dah, :dah, :dit),
      '/' => char_timing(:dah, :dit, :dit, :dah, :dit),
      '?' => char_timing(:dit, :dit, :dah, :dah, :dit, :dit)
    }
    return encoding[char]
  end

  def append_char_delay letr, wpm, ewpm
    @delay_time += char_delay(letr, wpm, ewpm)
  end


end
