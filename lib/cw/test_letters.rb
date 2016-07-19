# encoding: utf-8

class TestLetters < FileDetails

  include Tester

  def initialize
    super()
#    print_test_advice
  end

  def print_test_advice ; print.print_advice('Test Letters') ; end

  def process_input_word_maybe
    if @word_to_process
      stream.match_first_active_element @process_input_word # .strip
      @process_input_word = @word_to_process = nil
    end
  end

  def build_word_maybe
    @input_word ||= empty_string
    @input_word << key_chr if is_relevant_char?
    move_word_to_process if is_relevant_char?
  end

  def process_letter letr
    letr.downcase!
    sleep_char_delay letr
  end

  def print_marked_maybe
    @popped = stream.pop_next_marked
    print.char_result(@popped) if(@popped && ! print_letters?)
  end

end
