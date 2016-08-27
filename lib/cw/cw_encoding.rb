# encoding: utf-8

module CWG

  class CwEncoding

    include FileDetails

    def encodings
      if @encodings.nil?
        @encodings = load_code
      end
      @encodings
    end

    def load_code
      File.open(CODE_FILENAME, "r") do |code|
        YAML::load(code)
      end
    end

    def fetch char
      encodings[char]
    end

    def fetch_char pattern
      encodings.each_pair do |key, value|
        return key if(value == pattern)
      end
      return ''
    end

    def match_elements arg
      chars = []
      encodings.each_pair do |key, value|
        chars << key unless value.include?(:dot) if arg[0]  == :dashes
        chars << key unless value.include?(:dash) if arg[0] == :dots
        chars << key if (value.size < arg[1] )if arg[0]     == :less_than
        chars << key if (value.size > arg[1] )if arg[0]     == :greater_than
        chars << key if (value.size == arg[1] )if arg[0]    == :size
        chars.delete(' ')
      end
      chars
    end

  end
end
