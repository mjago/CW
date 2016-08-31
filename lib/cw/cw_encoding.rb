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

    def match_1 code
      code[0] == :dot ? 'e' : 't'
    end

    def match_2 code
      if code[0] == :dot
        if code[1] == :dot
          'i'
        elsif code[1] == :dash
          'a'
        end
      else
        if code[1] == :dot
          'n'
        elsif code[1] == :dash
          'm'
        end
      end
    end

    def match_3 code
      if code[0] == :dot
        if code[1] == :dot
          if code[2] == :dot
            's'
          else
            'u'
          end
        else
          if code[2] == :dot
            'r'
          else
            'w'
          end
        end
      else
        if code[1] == :dot
          if code[2] == :dot
            'd'
          else
            'k'
          end
        else
          if code[2] == :dot
            'g'
          else
            'o'
          end
        end
      end
    end

    def match_char code
      length = code.length
      case length
      when 1
        return match_1 code
      when 2
        return match_2 code
      when 3
        return match_3 code
      end
    end

    def fetch_char pattern
      return ' ' if pattern == [:space]
      temp = match_char pattern
      return temp if temp
      encodings.each_pair do |key, value|
        return key if(value == pattern)
      end
      return '*'
    end
  end
end
