# encoding: utf-8

class RepeatWord < FileDetails

  include Tester

  def initialize
    super
    @repeat_word = true
  end

  #overloaded #todo

  def print_failed_exit_words
    until stream.stream_empty?
      word = stream.pop[:value]
      print.prn_red word + ' ' unless @repeat_word
    end
  end

  def print_words words
    timing.init_char_timer
    (words.to_s + space).each_char do |letr|
      process_letter letr
      loop do
        do_events
        process_space_maybe letr
        process_word_maybe
        break if timing.char_delay_timeout?
      end
      print.prn letr if print_letters?
      break if quit?
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
    print.results(@popped, :pass_only) if(@popped && ! print_letters?)
  end

  #overloaded #todo

  def double_words words
    temp = []
    words.each do |wrd|
      2.times { temp.push wrd }
    end
    temp
  end

  def run words
    temp_words = words.all
    temp_words = double_words temp_words if Params.double_words
    temp_words.each do |word|
      loop do
        @input_word, @words = '', Words.new
        @quit, @failed = nil, nil
        @words.add [word]
        @threads = CWThreads.new(self, thread_processes)
        @threads.run
        break unless @failed
        break if global_quit?
      end
      break if global_quit?
    end
    reset_stdin
    print.newline
  end
end