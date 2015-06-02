# encoding: utf-8

class Book < FileDetails

  include Tester

  def initialize book_details
#    prn.print_advice('Test Words')
    @book_details = book_details
    @print_letters = Params.print_letters
    super()
    read_book book_location
    find_sentences

#    print_book_advice
  end

  def sentence             ; @sentence ||= Sentence.new        ; end
  def find_sentences       ; sentence.find_all                 ; end
  def raw_text             ; sentence.text                     ; end
  def read_book(book)      ; sentence.read_book(book)          ; end
  def next_sentence        ; sentence.next                     ; end
  def change_sentence      ; sentence.change                   ; end
  def change_sentence?     ; sentence.change?                  ; end
  def repeat_sentence?     ; sentence.repeat?                  ; end
  def current_sentence     ; sentence.current                  ; end
  def current_sentence_ary ; sentence.current_to_array         ; end
  def sentence_index       ; sentence.index                    ; end
  def play_repeat_tone     ; audio_play_tone @repeat_tone      ; end
  def audio_play_tone t    ; audio.play_tone(t)                ; end
  def play_r_tone          ; audio_play_tone @r_tone           ; end
  def complete_word?       ; get_word_last_char == space       ; end
  def audio_stop           ; audio.stop if audio_still_playing?; end
  def book_location        ; @book_details.book_location       ; end
  def print_letters?       ; @print_letters && ! quit?         ; end
  def reset_sentence_flags ; sentence.reset_flags              ; end
  def audio_play_sentence  ; audio.play                        ; end
  def print_book_advice    ; print.print_advice('Play Book')     ; end

  def change_or_repeat_sentence?
    sentence.change_or_repeat?
  end

  def change_repeat_or_quit?
    change_or_repeat_sentence? || quit?
  end

  def check_sentence_navigation chr
    sentence.check_sentence_navigation chr
  end

  def progress_file
    File.expand_path(@progress_file, @text_folder)
  end

  def get_book_progress
    sentence.read_progress progress_file
    @current_sentence_index = sentence_index
  end

  def write_book_progress
    sentence.write_progress progress_file
  end

  def audio_play_repeat_tone_maybe
    play_repeat_tone if repeat_sentence?
  end

  def monitor_keys
    loop do
      get_key_input
      check_quit_key_input
      break if quit?
      check_sentence_navigation key_chr
      build_word_maybe
    end
  end

  def process_input_word_maybe
    if @word_to_process
      if @book_details.args[:output] == :letter
        stream.match_first_active_element @process_input_word # .strip #todo
      else
        stream.match_last_active_element @process_input_word.strip #todo
      end
      @process_input_word = @word_to_process = nil
    end
  end

  def build_word_maybe
    @input_word ||= empty_string
    @input_word << key_chr if is_relevant_char?
    if @book_details.args[:output] == :letter
      move_word_to_process if is_relevant_char? #todo
    else
      move_word_to_process if complete_word?
    end
  end

  def add_space sentence
    sentence + space
  end

  def compile_sentence
    audio.convert_words add_space current_sentence
  end

  def compile_and_play
    compile_sentence
    audio_play_sentence
    start_sync
  end

  def change_and_kill_audio
    change_sentence
    audio_stop
  end

  def next_sentence_or_quit?
    playing = audio_still_playing?
    next_sentence unless playing
    sleep 0.01         if playing
    if change_repeat_or_quit?
      change_and_kill_audio
#todo      prn.newline unless quit?
      true
    end
  end

  def await_next_sentence_or_quit
    loop do
      break if next_sentence_or_quit?
    end
  end

  def quit_or_process_input?
    quit? || @word_to_process
  end

  def process_letter letr
    current_word.process_letter letr
    sleep_char_delay letr
  end

  def print_marked_maybe
    @popped = stream.pop_next_marked
    if @book_details.args[:output] == :letter
      print.char_result(@popped) if(@popped && ! print_letters?) #todo
    else
      print.results(@popped) if(@popped && ! print_letters?)
    end
  end

  def print_words words
    timing.init_char_timer
    (words + space).each_char do |letr|
      process_letter letr
      stream.add_char(letr) if @book_details.args[:output] == :letter
      loop do
        process_space_maybe(letr) unless @book_details.args[:output] == :letter
        process_word_maybe
        if change_repeat_or_quit?
          break
        end
        break if timing.char_delay_timeout?
      end
      print.prn letr if print_letters?
      break if change_repeat_or_quit?
    end
  end

  def print_words_for_current_sentence
    print_words current_sentence
  end

  def make_sentence_index_current
    @current_sentence_index = sentence_index
  end

  def sentence_index_current?
    @current_sentence_index && (@current_sentence_index == sentence_index)
  end

  def play_sentences_until_quit
    get_book_progress
    loop do
      check_sentence_count :play
      sync_with_print
      audio_play_repeat_tone_maybe
      reset_sentence_flags
      compile_and_play
      await_next_sentence_or_quit
      break if quit?
    end
    print_words_exit unless @print_letters
  end

  def check_sentence_count source
    if @book_details.session_finished? source
      audio_stop
      quit
      reset_stdin
      kill_threads
    end
  end

  def print_sentences_until_quit
    loop do
      check_sentence_count :print
      sync_with_play
      break if quit?
      sync_with_audio_player
      print_words_for_current_sentence
      print.reset
      puts
    end
  end

  def play_sentences_thread
    play_sentences_until_quit
    write_book_progress
    #    kill_threads
    print "\n\rplay has quit " if @debug
  end

  def print_sentences_thread
    print_sentences_until_quit
    kill_threads
    print "\n\rprint has quit " if @debug
  end

  def thread_processes
    [:monitor_keys_thread,
     :play_sentences_thread,
     :print_sentences_thread]
  end

end
