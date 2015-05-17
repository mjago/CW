class TestWords < FileDetails

  def initialize
    @print_letters = Params.print_letters
    super()
#    print_test_advice
  end

  def quit?                ; @quit                             ; end
  def quit                 ; @quit = true                      ; end
  def prn                  ; @print ||= Print.new              ; end
  def timing               ; @timing ||= Timing.new            ; end
  def audio                ; @audio ||= AudioPlayer.new        ; end
  def kill_threads         ; @threads.kill                     ; end
  def space                ; ' '                               ; end
  def empty_string         ; ''                                ; end
  def spawn_play(cmd)      ; Process.spawn(cmd)                ; end
  def start_sync           ; @start_sync = true                ; end
  def get_key_input        ; key_input.read                    ; end
  def key_chr              ; key_input.char                    ; end
  def key_input            ; @key_input ||= KeyInput.new       ; end
  def is_relevant_char?    ; key_input.is_relevant_char?       ; end
  def quit_key_input?      ; key_input.quit_input?             ; end
  def stream               ; @stream ||= Stream.new            ; end
  def reset_stdin          ; key_input.reset_stdin             ; end
  def current_word         ; @current_word ||= CurrentWord.new ; end
  def init_char_timer      ; timing.init_char_timer            ; end
  def print_test_words     ; print_words @words                ; end
  def audio_still_playing? ; audio.still_playing?              ; end
  def print_test_advice    ; prn.print_advice('Test Words')    ; end
  def blank_line           ; puts "\r"; puts "\r"              ; end


  def add_space words
    str = ''
    words.to_array.collect { |word| str << word + space}
    str
  end

  def audio_play
    audio.convert_words add_space @words
    start_sync
    audio.play
  end

  def play_words_thread
    play_words_until_quit
    print "\n\rplay has quit " if @debug
  end

  def play_words_until_quit
    audio_play
    play_words_exit unless @print_letters
  end

  def play_words_exit
    timing.init_play_words_timeout
    loop do
      break if quit?
      break if timing.play_words_timeout?
      sleep 0.01
    end
  end

  def print_words_thread
    print_words_until_quit
    kill_threads
    print "\n\rprint has quit " if @debug
  end

  def print_words_until_quit
    sync_with_audio_player
    print_test_words
    print_words_exit unless @print_letters
    quit
  end

  def print_failed_exit_words
    until stream.stream_empty?
      prn.prn_red stream.pop[:value]
    end
  end

  def print_words_exit
    timing.init_print_words_timeout
    loop do
      process_word_maybe
      break if stream.stream_empty?
      break if timing.print_words_timeout?
      break if quit?
      sleep 0.01
    end
    print_failed_exit_words
  end

  def print_words words
    timing.init_char_timer
    (words.to_s + space).each_char do |letr|
      process_letter letr
      loop do
        process_space_maybe letr
        process_word_maybe
        break if timing.char_delay_timeout?
      end
      prn.prn letr if print_letters?
      break if quit?
    end
  end

  def audio_stop
    audio.stop if audio_still_playing?
  end

  def wait_player_startup_delay
    audio.startup_delay
  end

  def sync_with_audio_player
    wait_for_start_sync
    wait_player_startup_delay
  end

  def check_quit_key_input
    if quit_key_input?
      quit
      audio_stop
    end
  end

  def monitor_keys
    loop do
      get_key_input
      check_quit_key_input
      break if quit?
      #      check_sentence_navigation key_chr
      build_word_maybe
    end
  end

  def push_letter_to_current_word letr
    current_word.push_letter letr
  end

  def process_input_word_maybe
    if @word_to_process
      stream.match_last_active_element @process_input_word.strip
      @process_input_word = @word_to_process = nil
    end
  end

  def get_word_last_char
    @input_word.split(//).last(1).first
  end

  def wait_for_no_word_process
    while @word_to_process
      sleep 0.1
    end
  end

  def complete_word?
    get_word_last_char == space
  end

  def move_word_to_process
    wait_for_no_word_process
    @process_input_word, @input_word, @word_to_process = @input_word, '', true
  end

  def build_word_maybe
    @input_word ||= empty_string
    @input_word << key_chr if is_relevant_char?
    move_word_to_process if complete_word?
  end

  def start_sync?
    if @start_sync
      @start_sync = nil
      true
    else
      nil
    end
  end

  def sleep_char_delay letr
    timing.append_char_delay letr, Params.wpm, Params.effective_wpm
  end

  def wait_for_start_sync
    until start_sync?
      sleep 0.001
      break if quit?
    end
  end

  def process_space_maybe letr
    if letr == space
      stream.add current_word.strip
      current_word.clear
      letr.clear
      prn.prn space if print_letters?
    end
  end

  def process_letter letr
    current_word.process_letter letr
    sleep_char_delay letr
  end

  def print_marked_maybe
    @popped = stream.pop_next_marked
    prn.results(@popped) if(@popped && ! print_letters?)
  end

  def process_word_maybe
    print_marked_maybe
    process_input_word_maybe
  end

  def print_letters?
    @print_letters && ! quit?
  end

  def sync_with_play
    loop do
      break if sentence_index_current?
      break if quit?
      sleep 0.015
    end
  end

  def sync_with_print
    loop do
      make_sentence_index_current if ! sentence_index_current?
      break if sentence_index_current?
      break if quit?
      sleep 0.015
    end
  end

  def monitor_keys_thread
    monitor_keys
    print "\n\rmonitor keys has quit " if @debug
  end

  def thread_processes
    [:monitor_keys_thread,
     :play_words_thread,
     :print_words_thread]
  end

  def run words
    @words = words
    @threads = CWThreads.new(self, thread_processes)
    @threads.run
    reset_stdin
    blank_line
  end

end
