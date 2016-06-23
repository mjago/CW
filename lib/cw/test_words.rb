# encoding: utf-8

class TestWords < FileDetails

  include Tester

  def initialize
    @print_letters = Params.print_letters

    super()

#    print_test_advice
  end

  def print_test_advice    ; print.print_advice('Test Words')    ; end

  def print_failed_exit_words
    until stream.stream_empty?
      print.fail stream.pop[:value] + ' '
    end
  end

  def process_input_word_maybe
    if @word_to_process
      stream.match_last_active_element @process_input_word.strip
      @process_input_word = @word_to_process = nil
    end
  end

  def build_word_maybe
    @input_word ||= empty_string
    @input_word << key_chr if is_relevant_char?
    move_word_to_process if complete_word?
  end

  def process_letter letr
    current_word.process_letter letr
    sleep_char_delay letr
  end

  def print_marked_maybe
    @popped = stream.pop_next_marked
    print.results(@popped) if(@popped && ! print_letters?)
  end

end
