# encoding: utf-8

module CWG

  class RepeatWord < Tester

    #overloaded #todo

    #  def print_failed_exit_words
    #    until stream.stream_empty?
    #      word = stream.pop[:value]
    #    end
    #    puts "empty!"
    #  end

    def print_words words
      timing.init_char_timer
      (words.to_s + ' ').each_char do |letr|
        process_letter letr
        loop do
          do_events
          process_space_maybe letr
          process_word_maybe
          break if timing.char_delay_timeout?
        end
        print.success letr if print_letters?
      end
    end

    def process_input_word_maybe
#      puts "process_input_word_maybe"
      if @word_to_process
        stream.match_last_active_element @process_input_word.strip
        @process_input_word = @word_to_process = nil
      end
    end

    def build_word_maybe
      @input_word ||= ''
      @input_word << key_chr if is_relevant_char?
      move_word_to_process if complete_word?
    end

    def process_letter letr
      current_word.process_letter letr
      sleep_char_delay letr
    end

    def print_marked_maybe
      @popped = stream.pop_next_marked
      print.results(@popped, :pass_only) if(@popped && ! print_letters?)
    end

    def test_env
      if(ENV["CW_ENV"] == "test")
        @words = []
        return true
      end
    end

    def threads
      threads ||= CWThreads.new(self, thread_processes)
    end

    def run words
      temp_words = words.all
      temp_words.each do |word|
        loop do
          Cfg.config.params["exit"] = false
          break if test_env
          @input_word, @words = '', Words.new
          Cfg.config.params["quit"] = false
          @words.assign word
          threads.run
          #          threads.start_threads
          #          threads.wait_for_threads
          @play = nil
          system("stty -raw echo")
          break unless failed?
        end
      end
      Cfg.config.params["exit"] = true
    end
  end
end
