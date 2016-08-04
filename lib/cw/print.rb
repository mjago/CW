# encoding: utf-8

require 'paint'
require 'io/console'

module CWG

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

        print Paint["#{value} ", success_colour] if success
        print Paint["#{value} ", fail_colour ] unless (success || type == :pass_only)
        return true
      end
    end

    def paint(value, colour)
      Paint[value, colour]
    end

    def paint_success_failure(popped)
      print paint(popped[:value], success_colour) if popped[:success]
      print paint(popped[:value], fail_colour ) unless popped[:success]
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
        print paint('*', list_colour)
        puts
      end
    end

    def fail word
      print paint("#{word}", fail_colour)
    end

    def list word
      print paint("#{word}", list_colour)
    end

    def success word
      newline_maybe word
      return if(@print_count == 0 && word == ' ')
      print paint("#{word}", success_colour)
    end

    def success_colour
      Cfg.config["success_colour"].to_sym || :blue
    end

    def fail_colour
      Cfg.config["fail_colour"].to_sym || :red
    end

    def list_colour
      Cfg.config["list_colour"].to_sym || :default
    end

    def print_advice name
      puts "#{name}: Press Q 4 times to Exit"
    end

  end

end
