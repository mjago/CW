# encoding: utf-8

module CWG

  #class Cl performs command-line processing

  class Cl

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

    def cl_squarewave
      "Cfg.config[\"tone\"] = #{Cfg.config["tone"]}"
      return '' unless Cfg.config["tone"].to_s == "squarewave"
      "-T #{@tone[:squarewave]} "
    end

    def cl_sawtooth
      "Cfg.config[\"tone\"] = #{Cfg.config["tone"]}"
      return '' unless Cfg.config["tone"].to_s == "sawtooth"
      "-T #{@tone[:sawtooth]} "
    end

    def cl_sinewave
      "Cfg.config[\"tone\"] = #{Cfg.config["tone"]}"
      return '' unless Cfg.config["tone"].to_s == "sinewave"
      "-T #{@tone[:sinewave]} "
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
        "-N 5 -B 1000 " : ''
    end

    def cl_audio_filename
      "-o \"#{File.expand_path(Cfg.config["audio_filename"], Cfg.config["audio_dir"])}\" "
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
      if quality && quality.class == Fixnum
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
