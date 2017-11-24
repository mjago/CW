# encoding: utf-8

module CWG

  module TextHelpers

    def letter_group
      (97..122).collect {|e| e.chr}
    end

    def number_group
      (48..57).collect {|e| e.chr}
    end

    def cw_chars chr
      chr.tr('^a-z0-9\.\,+', '')
    end

    def exclude_non_cw_chars word
      temp = ''
      word.split.each do |chr|
        temp += chr if letter(chr)
      end
      temp
    end

  end

end
