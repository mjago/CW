# encoding: utf-8

module CW
  class Reveal < Tester

    def initialize
      @reveal_buf = ''
      puts 'Reveal mode:'
    end

    def print_test_advice    ; print.print_advice('Test Words')    ; end

    def print_failed_exit_words
      until stream.stream_empty?
        @reveal_buf += stream.pop[:value] + ' '
      end
      print.success @reveal_buf
    end

    def process_input_word_maybe
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
      if @popped
        @reveal_buf += @popped[:value] + ' '
      end
    end
  end
end
