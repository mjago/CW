# encoding: utf-8

module CW
  class Encoding

    include FileDetails

    def initialize
      @char_lookup = "*eish54v*3uf***!2arl***+*wp**j*1tndb6=x/*kc**y**mgz7*q**o*8**90*".split('').map(&:to_sym)
    end

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
        chars << key unless value.include?(:dot)  if arg[0] == :dashes
        chars << key unless value.include?(:dash) if arg[0] == :dots
        chars << key if ( value.size < arg[1] )   if arg[0] == :less_than
        chars << key if ( value.size > arg[1] )   if arg[0] == :greater_than
        chars << key if ( value.size == arg[1] )  if arg[0] == :size
        chars.delete(' ')
      end
      chars
    end

    def fast_match code
      index = 0
      dash_jump = 64
      code.each do |ele|
        #          puts "ele: #{ele}"
        dash_jump = dash_jump / 2
        index = index + ((ele == :dot) ? 1 : dash_jump)
      end
      return @char_lookup[index].to_s
    end

    def fetch_char code
      length = code.length
      case length
      when 1..5
        return ' ' if code == [:space]
      #        return fast_match code
        return encodings.key(code)
      when 0
        return '*'
      else
        temp = encodings.key(code)
        return temp if temp
        return '*' unless temp
      end
    end
  end
end
