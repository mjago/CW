# coding: utf-8
module CWG

  class Tx < Tester

    include ToneHelpers
    include FileDetails

    def initialize
      @max_amplitude = (Cfg.config["volume"].to_f > 1.0 ?
                          1.0 : Cfg.config["volume"].to_f)
      @wpm = Cfg.config["wpm"].to_f
      @frequency = Cfg.config["frequency"].to_i
      @effective_wpm = Cfg.config["effective_wpm"] ?
                         Cfg.config["effective_wpm"].to_f : @wpm
      @sample_rate = 2400
      @print = Print.new
      @words = []
      @recording = []
    end

    def core_audio
      @core_audio ||= Coreaudio.new
    end

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
      @words = []
      ary = []
      loop do
        unless(@words == [])
          temp = @words.split('')
          @words = []
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
        @char = key_input.read
        #        puts "@char = #{@char}"
        break if quit_key_input?
        break if quit?
        break if exit?
        check_sentence_navigation(@char) if self.class == Book
        check_clear
        build_word_maybe
      end
    end

    def check_clear
      if @char == "\e"
        @words = []
      end
    end

    def receive_mode
      STDOUT.puts "Receive Mode:\r"
      loop do
        char = key_input.read
        case char
        when '#'
          puts "\n\rTransmit Mode:\n\r"
          return
        when '|'
          capture
        when '\\'
          info
        when '>'
          return '>'
        when 'Q'
          puts "Quitting..."
          quit!
        else
          if @recording.include? ' '
            @recording = [char]
          else
            @recording << char
          end

          STDOUT.print char
        end
        sleep 0.001
      end
    end

    def capture
      puts "\n\r"
      puts "\r Menu:  [C]allsign,"
      puts "\r        [N]ame,"
      puts "\r        [L]ocation,"
      puts "\r        [R]st,"
      puts "\r        [T]emperature,"
      puts "\r        [S]tore,"
      puts "\r        [I]nfo,"
      puts "\r        [W]PM,"
      puts "\r        [Q]uit capture!"
      puts "\r        Use capital to capture"
      puts "\r"

      loop do
        char = key_input.read
        STDOUT.print char
        upcase = /[[:upper:]]/.match(char)
        case char.downcase
        when 'c'
          return capture_attribute :callsign, upcase
        when 'n'
          return capture_attribute :name, upcase
        when 'l'
          return capture_attribute :qth, upcase
        when 'r'
          return capture_attribute :rst, upcase
        when 't'
          return capture_attribute :temperature, upcase
        when 'i'
          return info
        when 's'
          return store
        when 'q'
          puts "\rCancelled!"
          return
        else
          puts "\nInvalid letter - try again!"
        end
        sleep 0.001
      end
    end

    def store
      puts "\n\r"
      puts "\rStoring info:"
      info
      @their_callsign
      @their_name
      @their_location
      @their_rst
      puts "\rCleared info!"
      puts "\r"
    end

    def capture_attribute(attr, use_recording = false)
      puts "\n\r"
      puts "Enter their #{attr.to_s} followed by SPACE"
      temp = use_recording ? @recording : []
      STDOUT.print temp.join('').delete(' ') if @recording
      @recording = []
      loop do
        char = key_input.read
        if key_input.is_relevant_char?(char)
          temp << char
          STDOUT.print char
          if ' ' == char
            temp << char
            clip = temp.join('').delete(' ')
            @their_callsign = clip if :callsign == attr
            @their_name  = clip if :name == attr
            @their_rst   = clip if :rst == attr
            @their_qth   = clip if :qth == attr
            @temperature = clip if :temperature == attr
            puts "\n\n\rTheir #{attr.to_s}: #{@their_callsign.upcase}\n\n\r" if :callsign == attr
            unless :callsign == attr
              puts "\n\n\rTemp: #{@temperature}°C\n\n\r" if :temperature == attr
              puts "\n\n\rTheir #{attr.to_s}: #{clip}\n\n\r" unless :temperature == attr
            end
            return
          end
        elsif char == 'Q'
          puts "\n\n\rCancelled!\n\n\r"
          return
        end
      end
    end

    def my_callsign
      morsify "m0gzg "
    end

    def their_callsign
      morsify @their_callsign unless @their_callsign.nil?
    end

    def return_with_k
      acknowledge
      morsify 'k '
    end

    def return_with_kn
      morsify '+ '
      acknowledge
      morsify 'kn '
    end

    def acknowledge
      their_callsign
      morsify 'de '
      my_callsign
    end

    def received_ok
      acknowledge
      morsify 'en en '
    end

    def sign_off
      morsify "ok om #{@their_name} 73 es tnx fer nice qso = hpe 2cuagn sn + "
      their_callsign
      morsify 'de '
      my_callsign
      morsify 'sk '
    end

    def stop
      morsify '= '
    end

    def long_cq
      morsify "cqcq cqcq de m0gzg m0gzg k "
    end

    def morsify sentence
      sentence.split('').collect{|letr| @words << letr}
    end

    def rst
      morsify "rst is 599  5nn = "
    end

    def name
      morsify "name is m a r t y n  martyn = "
    end

    def qth
      morsify "qth is o l d  w o o d nr l i n c o l n  lincoln = "
    end

    def weather
      morsify "hr wx is sunny with some clouds = temp #{@temperature}c = "
    end

    def dit_dit
      morsify 'e e '
    end

    def info
      now = Time.now.utc
      time = now.strftime("%H:%M:%S Z")
      date = now.strftime("%d/%m/%y")
      puts "\r----------------------------\r"
      puts "Time:       #{time}\r"
      puts "Date:       #{date}\r"
      puts "Temp:       #{@temperature}°C\r"
      puts "\r"
      callsign = @their_callsign.nil? ? '' : @their_callsign.upcase
      puts "Their Call: #{callsign}\r"
      puts "Their Name: #{@their_name}\r"
      puts "Their RST:  #{@their_rst}\r"
      puts "Their qth:  #{@their_qth}\r"
      puts "\r----------------------------\r"
      puts "\n\r"
    end

    def build_word_maybe
      @input_word ||= ''
      case @char
      when '#'
        if '>' == receive_mode
          return_with_k
        end
      when '.'
        stop
      when 'F'
        @wpm += 1
        @effective_wpm = @wpm
      when 'S'
        @wpm -= 1
        @effective_wpm = @wpm
      when '='
        morsify '= '
      when ','
        morsify ', '
      when '\\'
        info
      when '|'
        capture
      when '?'
        morsify '? '
      when '@'
        long_cq
      when '£'
        my_callsign
      when '$'
        their_callsign
      when '}'
        sign_off
      when '>'
        return_with_k
      when ')'
        return_with_kn
      when '('
        received_ok
      when '^'
        qth
      when '%'
        rst
      when '&'
        name
      when '*'
        weather
      when 'E'
        dit_dit
      when "\n"
        puts "\r"
      when "\r"
        puts "\r"
      when 'Q'
        puts "Quitting..."
        quit!
      else
        if key_input.is_relevant_char?(@char)
          @words << @char
        end
      end
      @char = ''
    end

    def print_words_until_quit
      #      sync_with_audio_player
      print_words @words
      print_words_exit
      quit
    end

    def print_words words
      timing.init_char_timer
      #      p words
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
        :tx_words_thread,
        #        :print_words_thread
      ]
    end

    def word_composite word
      send_char word.downcase
    end

    def push_enc chr
      arry = []
      chr.each_with_index do |c,idx|
        arry << c
        arry << ((last_element?(idx, chr)) ? (space_or_espace) : space)
      end
      arry += char_space
    end

    def cw_encoding
      @encoding ||= CwEncoding.new
    end

    def space_or_espace
      (@effective_wpm == @wpm) ? space : e_space
    end

    def char_space
      @effective_wpm == @wpm ? [space,space] : [e_space,e_space]
    end

    def word_space
      @effective_wpm == @wpm ? [space] : [e_space]
    end

    def send_char c
      enc = nil
      if c == ' '
        enc = word_space
      else
        enc = cw_encoding.fetch(c).map { |e| send(e)}
      end
      push_enc enc
    end

    def generate wrds
      word_parts(wrds)
      create_element_methods
      temp = @word_parts.collect {|part| word_composite(part) }
      @word_parts = nil
      wpm = 1.5
      core_audio.start
      th = Thread.start do
        temp.each do |letr|
          letr.each do |ele|
            if (:space == ele[:name]) || (:e_space == ele[:name])
              core_audio.generate_silence(tone.data[
                                            ele[:name]][:spb] * 20)
            else
              core_audio.generate_tone( tone.data[
                                          ele[:name]][:spb] * 20)
            end
          end
        end
      end
      th.join
      sleep 0.1
      core_audio.stop
      th.kill.join
      #      puts 'end thread'
    end

    def word_parts str = nil
      return @word_parts if @word_parts
      @word_parts = []
      str.split('').each { |part| @word_parts << part}
      @word_parts
    end

    def create_element_method ele
      define_singleton_method(ele) {tone.data[ele]}
    end

    def create_element_methods
      elements.each do |ele|
        create_element_method ele
      end
    end

    def elements
      [:dot, :dash, :space, :e_space]
    end

    def tone
      @tone ||= ToneGenerator.new
    end

    def listen words
      cw_threads = CWThreads.new(self, thread_processes)
      cw_threads.run
      #      core_audio.play_tone(2)
      #      core_audio.play_tone(1)
      #      core_audio.play_tone(3)
    end

    def tx_words_thread
      loop do
        unless @words == []
          #          p @words
          temp = @words.shift
          STDOUT.print temp
          generate temp
        end
        #        puts 'here'
        sleep 0.01
      end
    end
  end
end
