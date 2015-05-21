class TestLetters < FileDetails

  include Tester

  def initialize
    @print_letters = Params.print_letters
    super()
#    print_test_advice
  end

  def print_test_advice    ; prn.print_advice('Test Letters')  ; end

# >   def print_failed_exit_words
# >     until stream.stream_empty?
# >       prn.prn_red stream.pop[:value]
# >     end
# >   end

  def print_words words
    timing.init_char_timer
    (words.to_s + space).each_char do |letr|
      process_letter letr
      stream.add_char letr
      loop do
#        process_space_maybe letr
        process_word_maybe
        break if timing.char_delay_timeout?
      end
      prn.prn letr if print_letters?
      break if quit?
    end
  end

  def process_input_word_maybe
    if @word_to_process
      stream.match_first_active_element @process_input_word # .strip
      @process_input_word = @word_to_process = nil
    end
  end

  def build_word_maybe
    @input_word ||= empty_string
    @input_word << key_chr if is_relevant_char?
    move_word_to_process if is_relevant_char? # complete_word?
  end

  def process_letter letr
    letr.downcase!
#    current_word.process_letter letr
    sleep_char_delay letr
  end

  def print_marked_maybe
    @popped = stream.pop_next_marked
    prn.char_result(@popped) if(@popped && ! print_letters?)
  end

end
