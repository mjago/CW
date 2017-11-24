# coding: utf-8

module CW
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
      print.rx "\n"
      print.tx "\n"
      print.menu "\n"
    end

    def core_audio
      @core_audio ||= Coreaudio.new
    end

    def add_space words
      str = ''
      words.to_array.collect { |word| str << word + ' '}
      str
    end

    def monitor_keys
      @char = '#'
      process_letter

      loop do
        @char = key_input.read
        break if quit_key_input?
        break if quit?
        break if exit?
        check_sentence_navigation(@char) if self.class == Book
        check_clear @char
        process_letter
      end
    end

    def check_clear char
      if char == "\e"
        @words = []
      end
    end

    def print_mode(mode)
      msg = "\n\r" + (mode == :rx ?
                        "Receive Mode:" :
                        "Transmit Mode:") + "\n\r"
      print.tx msg if :tx == mode
      print.rx msg if :rx == mode
    end

    def receive_mode
      print_mode :rx
      loop do
        char = key_input.read
        check_clear char
        case char
        when '#'
          print_mode :tx
          return
        when '|'
          capture
        when '\\'
          info
        when '>'
          return '>'
        when "\n"
          puts "\n"
        when "\r"
          puts "\r"
        when 'Q'
          puts "Quitting..."
          quit!
        else
          if(@recording.include? ' ')
            @recording = [char]
          else
            @recording << char
          end
          puts 'here'
          print.rx char
        end
        sleep 0.001
      end
    end

    def quit!
      Cfg.config.params["exit"] = true
    end

    def capture
      puts "\n\r"
      puts "\r Menu: [C]allsign,    [N]ame, "
      puts "\r       [L]ocation,    [R]st,  "
      puts "\r       [T]emperature, [S]tore,"
      puts "\r       [I]nfo,        [W]PM,  "
      puts "\r       [Q]uit capture!"
      puts "\r"
      puts "\r        Use CAPITAL to capture"

      loop do
        char = key_input.read
#        print.menu char
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
          puts "\nInvalid letter(#{char}) - try again!"
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

    def capture_attribute(attr_type, use_recording = false)
      puts "\n\r"
      puts "Enter their #{attr_type.to_s} followed by SPACE" unless use_recording
      temp = use_recording ? @recording : []
      print.menu temp.join('').delete(' ') if(@recording && ! use_recording)
      @recording = []
      if use_recording
        write_attribute temp, attr_type
        return
      end
      loop do
        char = key_input.read
        if key_input.is_relevant_char?(char)
          temp << char
          print.menu char unless use_recording
          if ' ' == char
            temp << char
            write_attribute temp, attr_type
            return
          end
        elsif char == 'Q'
          puts "\n\n\rCancelled!\n\n\r"
          return
        end
      end
    end

    def write_attribute attr, type
      clip = attr.join('').delete(' ')
      @their_callsign = clip if :callsign == type
      @their_name  = clip    if :name == type
      @their_rst   = clip    if :rst == type
      @their_qth   = clip    if :qth == type
      @temperature = clip    if :temperature == type
      puts "\n\n\r#{type.to_s}: #{@their_callsign.upcase}\n\n\r" if :callsign == type
      unless :callsign == type
        puts "\n\n\rAttr: #{@temperature}°C\n\n\r" if :temperature == type
        puts "\n\n\rTheir #{type.to_s}: #{clip}\n\n\r" unless :temperature == type
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
      morsify ' de '
      my_callsign
    end

    def received_ok
      acknowledge
      morsify 'en en '
    end

    def sign_off
      morsify "ok om #{@their_name} 73 es tnx fer nice qso = hpe 2cuagn sn + "
      their_callsign
      morsify ' de '
      my_callsign
      morsify ' sk '
    end

    def stop
      morsify '= '
    end

    def long_cq
      morsify "cqcq cqcq de m0gzg m0gzg k "
    end

    def morsify sentence
      sentence.split('').collect{ |letr| char_to_tx letr }
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

    def process_letter
      @input_word ||= ''
      case @char
      when '#'
        return_val = receive_mode
        if '>' == return_val
          return_with_k
        else
          @char = ''
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
        puts "\n"
      when "\r"
        puts "\r"
      when 'Q'
        puts "Quitting..."
        quit!
      else
        if key_input.is_relevant_char?(@char)
          char_to_tx @char
        end
      end
      @char = ''
    end

    def char_to_tx char
      @words << char
#      print.tx char
    end

    def thread_processes
      [
        :tx_words_thread,
        :monitor_keys_thread,
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
      @encoding ||= Encoding.new
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

    def audio_thread
      temp = @word_parts.collect {|part| word_composite(part) }
      @word_parts = nil
      wpm = 1.5
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

    def generate wrds
      word_parts(wrds)
      create_element_methods
      core_audio.start
      cw_threads.add self, :audio_thread
      #      th = Thread.start do
      cw_threads.join :audio_thread
      sleep 0.001
      core_audio.stop
      cw_threads.kill_thread_x :audio_thread
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

    def cw_threads
      @cw_threads ||= Threads.new(self, thread_processes)
    end

    def tx string
      @winkey = Winkey.new
      @winkey.on
      @winkey.echo
      @winkey.no_weighting
      @winkey.wpm @wpm
#      @winkey.string "ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/=+?>(:;"
      @winkey.string ' fb '
      @winkey.wait_while_sending
      cw_threads.run
#      @winkey.close
    end

    def tx_words_thread
      loop do
        unless @words == []
          temp = @words.shift
          #          generate temp
#          p temp
          @winkey.stringtemp.to_s.upcase
          print.tx temp
        end
        sleep 0.01
      end
    end
  end
end
