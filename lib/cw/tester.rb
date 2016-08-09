# encoding: utf-8

module CWG

  class Tester

    def quit?                ; @quit                             ; end
    def quit                 ; @quit = true                      ; end
    def print                ; @print ||= Print.new              ; end
    def play                 ; @play ||= Play.new(@words)        ; end
    def timing               ; @timing ||= Timing.new            ; end
#    def audio                ; @audio ||= AudioPlayer.new        ; end
    def kill_threads         ; @threads.kill                     ; end
#    def start_sync           ; @start_sync = true                ; end
    def get_key_input        ; key_input.read                    ; end
    def key_chr              ; key_input.char                    ; end
    def key_input            ; @key_input ||= KeyInput.new       ; end
    def is_relevant_char?    ; key_input.is_relevant_char?       ; end
    def stream               ; @stream ||= CwStream.new          ; end
    def reset_stdin          ; key_input.reset_stdin             ; end
    def current_word         ; @current_word ||= CurrentWord.new ; end
    def init_char_timer      ; timing.init_char_timer            ; end

    def do_events
      sleep 0.005
    end

    def process_letters letr
      loop do
        do_events
        if self.class == Book
          process_space_maybe(letr) unless @book_details.args[:output] == :letter
          process_word_maybe
          break if change_repeat_or_quit?
          break if timing.char_delay_timeout?
        else
          process_space_maybe(letr) if(self.class == TestWords)
          process_space_maybe(letr) if(self.class == Reveal)
          process_word_maybe
          break if timing.char_delay_timeout?
        end
      end
    end

    def process_words words
      book_class = (self.class == Book)
      (words.to_s + ' ').each_char do |letr|
        process_letter letr
        if book_class
          stream.add_char(letr) if @book_details.args[:output] == :letter
        else
          stream.add_char(letr) if(self.class == TestLetters)
        end
        process_letters letr
        print.success letr if print_letters?
        break if(book_class && change_repeat_or_quit?)
        break if ((! book_class) && quit?)
      end
    end

    def print_words words
      timing.init_char_timer
      process_words words
    end

    def process_word_maybe
      print_marked_maybe
      process_input_word_maybe
    end

    def print_words_until_quit
      @failed = false
      sync_with_audio_player
      print_words @words
      print_words_exit unless Cfg.config["print_letters"]
      quit
    end

    def print_failed_exit_words
      until stream.stream_empty?
        print.fail stream.pop[:value]
      end
    end

    def finish?
      return true if stream.stream_empty?
      return true if timing.print_words_timeout?
      return true if quit?
      return false
    end

    def failed?
      @failed
    end

    def failed!
      @failed = true
    end

    def print_words_exit
      timing.init_print_words_timeout
      loop do
        process_word_maybe
        if finish?
          break
        end
        sleep 0.01
      end
      failed! unless stream.stream_empty?
      print_failed_exit_words #unless self.class == RepeatWord
    end

    def audio_stop
      play.stop if play.still_playing?
    end

    def sync_with_audio_player
      wait_for_start_sync
      play.wait_player_startup_delay
    end

    def push_letter_to_current_word letr
      current_word.push_letter letr
    end

    def get_word_last_char
      @input_word.split(//).last(1).first
    end

    def word_proc_timeout(arg = :status)
      if arg == :init
        @wp_timeout = Time.now + 5
      else
        return true if(Time.now > @wp_timeout)
      end
      return false
    end

    def wait_for_no_word_process
      word_proc_timeout(:init)
      while @word_to_process
        sleep 0.01
        if word_proc_timeout
          #        exit(1)
        end
      end
    end

    def complete_word?
      get_word_last_char == ' '
    end

    def move_word_to_process
      wait_for_no_word_process
      @process_input_word, @input_word = @input_word, ''
      @word_to_process = true
    end

    def sleep_char_delay letr
      timing.append_char_delay letr, Cfg.config["wpm"], Cfg.config["effective_wpm"]
    end

    def wait_for_start_sync
      timeout = Time.now + 5
      until play.start_sync?
        sleep 0.001
        break if quit?
        if timeout < Time.now
          Cfg.config.params["exit"] = true
          exit 1
        end
      end
    end

    def process_space_maybe letr
      if letr == ' '
        stream.push current_word.strip
        current_word.clear
        letr.clear
        print.success ' ' if print_letters?
      end
    end

    def print_letters?
      Cfg.config["print_letters"] && ! quit?
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
        break
      end
    end

    def play_words_thread
      p @words
      play.play_words_until_quit
      print "\n\rplay has quit " if @debug
      Cfg.config.params["exit"] = true
    end

    def print_words_thread
      print_words_until_quit
      print "\n\rprint has quit " if @debug
      Cfg.config.params["exit"] = true
    end

    def monitor_keys_thread
      monitor_keys
      print "\n\rmonitor keys has quit " if @debug
      Cfg.config.params["exit"] = true
    end

    def thread_processes
      [
        :monitor_keys_thread,
        :play_words_thread,
        :print_words_thread
      ]
    end

    def run words
      @words = words
      @cw_threads = CWThreads.new(self, thread_processes)
      @cw_threads.run
      @play = nil
      reset_stdin
      print.newline
    end

    def monitor_keys
      loop do
        key_input.read
        check_quit_key_input
        break if quit?
        break if Cfg.config["exit"]
        check_sentence_navigation(key_chr) if self.class == Book
        build_word_maybe
      end
    end

    def check_quit_key_input
      if key_input.quit_input?
        play.stop
        Cfg.config.params["exit"] = true
        quit
        play.stop
        true
      end
    end
  end
end
