# class CW provides Morse code generation functionality

class CW < Cw_dsl

  HERE = File.dirname(__FILE__) + '/'
  COMMON_WORDS = HERE + '../txt/common_words.txt'

  def initialize(&block)
    super(&block)
    @params = {
      :name          => 'unnamed',
      :wpm           => 25,
      :dictionary    => COMMON_WORDS,
      :audio_filename  => 'audio_output',
      :word_filename => 'words.txt',
    }

    instance_eval(&block) if block
    load_common_words unless @words.exist?
    run unless @params[:pause]
  end

#  def initialize(&block)
#  end

  def author (name)
    @params[:author] = name
  end

  def title (name)
    @params[:title] = name
  end

  def reload
    load_words(Params.dictionary)
  end

  def load_common_words
    load_words
  end

  def load_words(filename = COMMON_WORDS)
    Params.dictionary = filename
    @words.load filename
  end

  def to_s
    Str.new(@params).to_s
  end

  def set_tone_type(type)
    case type
    when :squarewave, :sawtooth, :sinewave
      @params[:tone] = type
    end
  end

  def assign_words(words)
    @words.assign words
  end

  def collect_words
    @words.collect_words
  end

  def audio_filename(filename)
    @params[:audio_filename] = filename
  end

  def quality(quality)
    @params[:quality] = quality
  end

  def command_line(command_line)
    @params[:command_line] = command_line
  end

  def save_word_file(filename = Params.word_filename)
    File.open(filename, 'w') do |file|
      file << collect_words
    end
  end

#  def convert(dry_run = nil)
#    words = @words.collect{ |wrd| wrd.gsub("\n","")}
#    cl = cl_echo(words)
#    ! dry_run ? `#{cl}` : cl
#  end

  def frequency(freq = nil)
    @params[:frequency] = freq if freq
    @params[:frequency]
  end

  def play(dry_run = nil)
    cmd = "afplay #{@params[:audio_filename]}0000.mp3"
    ! dry_run ? `#{cmd}` : cmd
  end

  def update_last_word
    @last_word = @current_word if(@last_word == '')
  end

  def check_match
    update_last_word
    if(@have_word &&
       (@last_word.downcase.strip == @entered_word.downcase.strip))
      print_green @last_word
      @last_word, @entered_word = '', ''
      @success, @have_word = true, nil
    end
  end

#  def print_words
#    sleep 0.5
#    start_time = Time.now
#    delay_time = start_time - start_time
#    dot = dot_ms(@params[:wpm])
#    temp = ''
#    @words.each_char do |letr|
#      @current_word  << letr
#      #          puts letr
#      delay_time += char_delay(letr, dot)
#      delay_time += (dot * 2)
#      sleep_until(start_time, delay_time)
#      if letr == ' ' || letr == '.'
#        @have_word = true
#        if((@last_word != '') && ( ! @success))
#          print_red(@last_word, @entered_word)
#          @entered_word = ''
#        elsif @success
#          @success = nil
#        end
#        @last_word, @current_word, = @current_word, ''
#      end
#    end
#  end



  #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
  #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
  #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
  #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
  #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
  #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
  #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
  #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
  #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
  #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

  #  def run
  ##    puts self.to_s
  #    #    time = Time.now + @word_spacing.round
  #    loop do
  #      @words = @rss_articles.shift if @rss_flag
  #      @rss_flag = nil unless @rss_articles
  #      @words = @words.join.downcase.gsub(/[^\w\s\d]/, '') if @words
  #      break unless @words
  #      #      puts "@words = #{@words}"
  #      #      save_word_file
  #      convert
  #      #      while(Time.now < time + @word_spacing)
  #      #        sleep 0.05
  #      #      end
  #
  #      @last_word = ''
  #      @entered_word = ''
  #      input_thread = Thread.new do
  #        monitor_keys
  #      end
  #
  #
  #      play_thread = Thread.new do
  #        play
  ##        puts 'hello'
  #      end
  #
  #      @current_word = ''
  #      #      play_thread.kill
  #      grep_thread = Thread.new do
  #        #        sleep 0.01
  #        `ps -ef | grep afplay`
  #        #        print "#{Process.pid}\n"
  #        #        print_words
  #      end
  #
  #      [input_thread, grep_thread, play_thread].each {|th| th.join}
  #
  #      #      sleep @word_spacing if @word_spacing
  #      #      time = Time.now
  #      break unless @rss_flag
  #    end
  #  end

  def pause
    @params[:pause] = true
  end

  #  def sign_off
  #    require 'gentone'
  #    tone = Gentone::Generator.new
  #    tone.generate 90, 1000
  #    sleep 0.030
  #    4.times do
  #      generate 30, 1000
  #      sleep 0.030
  #    end
  #    generate 90, 1000
  #  end

  alias_method :word_length,           :word_size
  alias_method :word_shuffle,          :shuffle
  alias_method :having_size_of,        :word_size
  alias_method :words_beginning_with,  :beginning_with
  alias_method :words_ending_with,     :ending_with
  alias_method :number_of_words,       :word_count
  alias_method :words_including,       :including
  alias_method :words_no_longer_than,  :no_longer_than
  alias_method :words_no_shorter_than, :no_shorter_than
  alias_method :random_alphanumeric,   :random_letters_numbers
  alias_method :comment,               :name
  alias_method :no_run,                :pause

end
