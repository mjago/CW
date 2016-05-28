# encoding: utf-8

require 'paint'
require 'io/console'

class Print

  class ProgressPrint
    def colour
      :yellow
    end

    def print x
      STDOUT.print Paint[x, colour]
    end
    def puts x
      STDOUT.puts  Paint[x, colour]
    end

    def flush
      STDOUT.flush
    end

    def tty?
      true
    end
  end

  def initialize
    update_console_size
    reset
  end

  def console_size
    IO.console.winsize
  rescue LoadError
    [Integer(`tput li`), Integer(`tput co`)]
  end

  def update_console_size
    @rows, @cols = console_size
#    printf "%d rows by %d columns\n", @rows, @cols
  end

  def reset
    @print_count = 0
    puts "\r"
  end

  def newline
    reset
    update_console_size
  end

  def force_newline_maybe
    if @print_count >= (@cols - 1)
      newline
      true
    end
  end

  def newline_maybe word
    @print_count += word.size unless force_newline_maybe
    return if((word.size == 1) && (word != ' '))
    if @print_count > (@cols - 10)
      newline
      true
    end
  end

  def results popped, type = :pass_and_fail
    if popped
      value = popped[:value]
      success = popped[:success]

      newline_maybe value

      print Paint["#{value} ", :blue] if success
      print Paint["#{value} ", :red ] unless (success || type == :pass_only)
      return true
    end
  end

  def paint(value, colour)
    Paint[value, colour]
  end

  def paint_success_failure(popped)
    print paint(popped[:value], :blue) if popped[:success]
    print paint(popped[:value], :red ) unless popped[:success]
  end

  def char_result popped
    unless newline_maybe popped[:value]
      popped[:value] = '_' if((popped[:value] == ' ') && (popped[:success] != true))
      paint_success_failure(popped)
      return true
    end
  end

  def heading
    "Current Sentence is     duration:    secs".length.times do
      print '*'
      puts
    end
  end

  def print_blue(word)
    print paint(word, :blue)
    cursor_pos = word.size
    (12 - cursor_pos).times{print ' '}
  end

  def print_green(word)
    print_blue(word)
    print paint("#{word} \r\n", :green)
  end

  def print_red word
    print paint("#{word }\r\n", :red)
  end

  def prn_red word
    print paint("#{word}", :red)
  end

  def print_fail(word, attempt)
    print_blue(word)
    print paint("#{attempt }\r\n", :red)
  end

  def prn(word)
    newline_maybe word
    return if(@print_count == 0 && word == ' ')
    print paint("#{word}", :blue)
  end

  def print_advice name
    puts "#{name}: Press Q 4 times to Exit"
  end

end
