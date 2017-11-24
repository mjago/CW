# encoding: utf-8

module CW

  #class Cl performs command-line processing

  class Cl

    include FileDetails

    def initialize
      @tone = {
        sinewave: 0,
        sawtooth: 1,
        squarewave: 2
      }
    end

    def cl_wpm
      wpm = Cfg.config["wpm"]
      wpm ? "-w #{wpm} " : ''
    end

    def cl_effective_wpm
      ewpm = Cfg.config["effective_wpm"]
      ewpm ? "-e #{ewpm} " : ''
    end

    def cl_word_spacing
      ws = Cfg.config["word_spacing"]
      ws ? "-W #{ws} " : ''
    end

    def cl_frequency
      freq = Cfg.config["frequency"]
      freq ? "-f #{freq} " : ''
    end

    def wave type
      return '' unless(Cfg.config["tone"].to_s == type)
      "-T #{@tone[type.to_sym]} "
    end

    def cl_squarewave
      wave 'squarewave'
    end

    def cl_sawtooth
      wave "sawtooth"
    end

    def cl_sinewave
      wave "sinewave"
    end

    def cl_author
      author = Cfg.config["author"]
      author ? "-a \"#{author}\" " : ''
    end

    def cl_title
      title = Cfg.config["title"]
      title ? "-t \"#{title}\" " : ''
    end

    def cl_noise
      Cfg.config["noise"] ?
        "-N 10 -B 800 " : ''
    end

    def cl_audio_filename
      "-o \"#{File.join(audio_dir, audio_filename)}\" "
    end

    def coarse_quality(quality)
      {
        :high =>   "-q 1 ",
        :medium => "-q 5 ",
        :low =>    "-q 9 "
      }[quality]
    end

    def cl_quality
      quality = Cfg.config["quality"]
      if quality && quality.class == 1.class
        "-q #{quality} "
      else
        coarse_quality quality
      end
    end

    def cl_command_line
      cl = Cfg.config["command_line"]
      cl ? "#{cl}" : ''
    end

    def build_command_line
      [ cl_wpm,
        cl_effective_wpm,
        cl_word_spacing,
        cl_frequency,
        cl_squarewave,
        cl_sawtooth,
        cl_sinewave,
        cl_author,
        cl_title,
        cl_noise,
        cl_audio_filename,
        cl_quality,
        cl_command_line
      ].collect{|param| param}.join
    end

    def ebook2cw_path
      Cfg.config["ebook2cw_path"] || 'ebook2cw'
    end

    def cl_echo words
      "echo #{words} | #{ebook2cw_path} #{build_command_line}"
    end

    def cl_full input
      "#{ebook2cw_path} #{build_command_line} #{input}"
    end

  end

end
