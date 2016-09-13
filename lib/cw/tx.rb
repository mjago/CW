require "coreaudio"

module CWG

  class Tx < Tester

    def process_input_word_maybe
      if @word_to_process
        puts "@process_input_word = #{@process_input_word}"
        play.audio.convert_words(@process_input_word)
        play.audio.play
#        stream.match_first_active_element @process_input_word # .strip
        @process_input_word = @word_to_process = nil
      end
    end

    def process_letter letr
      letr.downcase!
      sleep_char_delay letr
    end

    def print_marked_maybe
      @popped = stream.pop_next_marked
      print.char_result(@popped) if(@popped && ! print.print_letters?)
    end

    def audio
      @audio ||= AudioPlayer.new
    end

    def add_space words
      str = ''
      words.to_array.collect { |word| str << word + ' '}
      str
    end

    def play_words_thread
      @words = ''
      ary = []
      loop do
        unless(@words == '')
          temp =  @words.split('')
          @words = ''
          temp.each do |i|
            ary << i
          end
        end
        unless ary == []
          substr = ''
          if ary.include?(' ')
            idx = ary.index(' ')
            0.upto(idx - 1) do
              temp = ary.shift
              $stdout.print temp
              substr << temp
            end
            ary.shift
            $stdout.print(' ')
            audio.convert_words(substr)
            audio.play
          end
        end
      end
      exit
    end

    def monitor_keys
      loop do
        key_input.read
        break if quit_key_input?
        break if quit?
        break if exit?
        check_sentence_navigation(key_chr) if self.class == Book
        build_word_maybe
      end
    end

    def build_word_maybe
      @input_word ||= ''
      if is_relevant_char?
        @words << key_chr
        # move_word_to_process if is_relevant_char?
        #        @words.add @input_word.shift
        #        @input_word = ''
      end
    end

    #    play_words_exit unless Cfg.config["print_letters"]
    #    play.play_words_until_quit
    #    print "\n\rplay has quit " if @debug
    #    Cfg.config.params["exit"] = true
    #  end

    def print_words_until_quit
      #      sync_with_audio_player
      print_words @words
      print_words_exit
      quit
    end

    def print_words words
      timing.init_char_timer
      p words
      process_words words
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
        print.success letr if print.print_letters?
        break if(book_class && change_repeat_or_quit?)
        break if ((! book_class) && quit?)
      end
    end

    def print_words_thread
      print_words_until_quit
      print "\n\rprint has quit " if @debug
      Cfg.config.params["exit"] = true
    end

    def thread_processes
      [
        :monitor_keys_thread,
        :play_words_thread,
#        :print_words_thread
      ]
    end

    def tone
      @tone ||= ToneGenerator.new
    end

    def listen words
      play_tone
    end

    def filter_maybe(size, count)
      @max_amplitude = 1
      ramp = 1
      ramp_point =  @max_amplitude / ramp
      ampl = (count < ramp_point) ? (ramp * count) : @max_amplitude
      (count > (size - ramp_point)) ? (ramp * (size - count)) : ampl
    end

    include ToneHelpers

    def generate_tone(number_of_samples)
    @sample_rate = 44100
    @frequency = 1000
    @w = (@frequency * TWO_PI) / @sample_rate
      ary = []
      number_of_samples.round.times do |sample_number|
        amplitude = filter_maybe(number_of_samples, sample_number)
        sine_radians = @w * sample_number
        temp = (amplitude * Math.sin(sine_radians) * 0x7FFF).round
#        puts temp
        ary << temp
      end
      ary
    end

    def generate_silence(number_of_samples)
      ary = []
      number_of_samples.round.times do |sample_number|
        ary << 0.0
      end
      ary
    end

    def play_tone
      dev = CoreAudio.default_output_device
      buf = dev.output_buffer(8192)
      #      phase = Math::PI * 2.0 * 440.0 / dev.nominal_rate
      th = Thread.start do
        #        i = 0
        #        loop do
        #        wav = NArray.sint(1024)
        wpm = 3.5
        17.times do
          wpm -= 0.2
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm * 3)
          buf<< generate_silence(1024 * wpm * 3)

          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm * 3)
          buf<< generate_silence(1024 * wpm * 3)

          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm * 3)
          buf<< generate_silence(1024 * wpm * 3)

          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm * 3)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm * 3)

          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm * 3)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm * 3)

          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm * 3)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm * 3)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm * 3)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm)
          buf << generate_tone(1024 * wpm)
          buf<< generate_silence(1024 * wpm * 3)
        end
      end
      buf.start
      th.join
#      sleep 6
      buf.stop
      puts "#{buf.dropped_frame} frame dropped."
      th.kill.join

      #     def listen words
      #       play_tone
      # #      @words = words
      # #      p @words
      # #      @cw_threads = CWThreads.new(self, thread_processes)
      # #      @cw_threads.run
      # #      reset_stdin
      # #      print.newline
      #     end
      #
      #   end

    end

#module CWG
#
#  class Tx < Tester
#    def thread_processes
#      [
#        :read
##        :echo
#      ]
#    end
#
#    def read
#      loop do
#        key_input.read
#        exit 1
##        @temp << key_chr if is_relevant_char?
#        sleep 0.1
#      end
#    end
#
#    def run
##      @audio = AudioPlayer.new
#
##      @cw_threads = CWThreads.new(self, thread_processes)
##      @cw_threads.run
#
#      read
##      exit 1
##      loop do
##      @temp = STDIN.gets
##        temp = "one two three four five six seven eight nine ten"
#
##      @temp.gsub!("\n",' ')
##        temp.gsub!(' ','')
#
#
##        @cw_threads = CWThreads.new(self, thread_processes)
##        @cw_threads.run
##        reset_stdin
##        print.newline
#
##                start_sync()
##      end
#    end
#
#    def echo
#      loop do
#        @temp ||= ''
#        if @temp != ''
#          puts "@temp = #{@temp}"
#          chr = @temp.shift
#          puts "chr = #{chr}"
#          @audio.convert_words(chr)
#          @audio.play
#        end
#        sleep 0.1
#      end
#    end

  end
end
