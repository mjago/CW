# encoding: utf-8

module CW
  class Play

    def initialize words
      @words = words
    end

    def quit?
      if Cfg.config["quit"].nil?
        Cfg.config.params["quit"] = false
        Cfg.config["quit"]
      end
    end

    def audio
      @audio ||= AudioPlayer.new
    end

    def init_play_words_timeout
      @start_play_time, @delay_play_time = Time.now, 2.0
    end

    def play_words_timeout?
      (Time.now - @start_play_time) > @delay_play_time
    end

    def start_sync
      @start_sync = true
    end

    def start_sync?
      if @start_sync
        @start_sync = nil
        true
      else
        nil
      end
    end

    def wait_player_startup_delay
      sleep 0.2
    end

    def add_space words
      str = ''
      words.to_array.collect { |word| str << word + ' '}
      str
    end

    def play
      audio.play
    end

    def play_audio
      audio.convert_words add_space @words
      start_sync()
      play
    end

    def play_words_exit
#      puts "play_words_exit"
      init_play_words_timeout
      loop do
        break if quit?
        break if play_words_timeout?
        if Cfg.config["exit"]
          audio.stop
          break
        end
        sleep 0.01
      end
      #      Cfg.config["exit"] = true
      sleep 0.1
    end

    def play_words_until_quit
      play_audio
      play_words_exit unless Cfg.config["print_letters"]
    end

    def still_playing?
      audio.still_playing?
    end

    def stop
      audio.stop
    end
  end
end
