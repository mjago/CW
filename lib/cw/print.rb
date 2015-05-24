require 'paint'
require 'io/console'

class Print

  def initialize
    update_console_size
    @print_count = 0
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

  def newline
    @print_count = 0
    puts "\r"
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

  def results popped
    if popped
      value = popped[:value]
      success = popped[:success]

      newline_maybe value

      print Paint["#{value} ", :blue]     if success
      print Paint["#{value} ", :red ] unless success
      return true
    end
  end

  def char_result popped
    if popped
      value = popped[:value]
      success = popped[:success]

      unless newline_maybe value
        #return if @print_count == 0 && value == ' '
        value = '_' if((value == ' ') && (success != true))
        print Paint["#{value}", :blue]     if success
        print Paint["#{value}", :red ] unless success
        return true
      end
    end
  end

  def heading
    puts ("*" * "Current Sentence is     duration:    secs".length) + "\r"
  end

  def print_blue(word)
    print Paint[word, :blue]
    cursor_pos = word.size
    (12 - cursor_pos).times{print ' '}
  end

  def print_green(word)
    print_blue(word)
    print Paint["#{word} \r\n", :green]
  end

  def print_red word
    print Paint["#{word }\r\n", :red]
  end

  def prn_red word
    print Paint["#{word}", :red]
  end

  def print_fail(word, attempt)
    print_blue(word)
    print Paint["#{attempt }\r\n", :red]
  end

  def prn(word)
    newline_maybe word
    return if(@print_count == 0 && word == ' ')
    print Paint["#{word}", :blue]
  end

  def print_advice name
    puts "#{name.to_s}: Press Q 4 times to Exit"
  end
end
