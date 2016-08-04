# encoding: utf-8

module CWG

  #class Str

  class Str

    include TextHelpers

    def initialize
      @seperator = ', '
    end

    def to_s
      delim  = delim_str
      [
        ("#{Cfg.config["name"]}\n" if(Cfg.config["name"])),
        delim,
        wpm_str,
        word_count_str,
        word_size_str,
        beginning_str,
        ending_str,
        including_str,
        containing_str,
        delim
      ].collect{ |prm| prm.to_s }.join
    end

    def stringify ary
      ary.join(@seperator)
    end

    def word_count_str
      "Word count: #{Cfg.config["word_count"]}\n"
    end

    def wpm_str
      "WPM:        #{Cfg.config["wpm"]}\n"
    end

    def word_size_str
      Cfg.config["size"] ? "Word size:  #{Cfg.config["size"]}\n" : nil
    end

    def delim_str
      size = Cfg.config["name"] ? Cfg.config["name"].size : 8
      "#{'=' * size}\n"
    end

    def beginning_str
      beginning = Cfg.config["begin"]
      beginning ? "Beginning:  #{stringify beginning}\n" : nil
    end

    def ending_str
      ending = Cfg.config["end"]
      ending ? "Ending:     #{stringify ending}\n" : nil
    end

    def including_str
      including = Cfg.config["including"]
      including ? "Including:  #{stringify including}\n" : nil
    end

    def containing_str
      containing = Cfg.config["containing"]
      containing ? "Containing: #{stringify containing}\n" : nil
    end

  end

end
