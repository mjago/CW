# encoding: utf-8

module CW

  #class Randomize provides character randomising

  class Randomize

    def initialize(options, chars)
      @options = options
      @chars = chars
    end

    def word_count
      @options[:count] ? @options[:count] : 50
    end

    def size
      @options[:size] ? @options[:size] : 4
    end

    def lengthen_chars
      @chars += @chars while(@chars.length < size)
    end

    def shuffle_chars
      @chars.shuffle!
    end

    def take_chars size
      @chars.take size
    end

    def chars_to_alpha
      @chrs.collect{|char| char.chr}.join
    end

    def has_no_letter?
      @alpha[/[a-zA-Z]+/] == @alpha
    end

    def has_no_number?
      @alpha[/[0-9]+/] == @alpha
    end

    def missing_letters_or_numbers?
      if @options && @options[:letters_numbers]
        return true if has_no_letter?
        return true if has_no_number?
      end
    end

    def process_chars
      lengthen_chars
      shuffle_chars
      @chrs = take_chars size
      @alpha = chars_to_alpha
    end

    def chars_processed?
      process_chars
      ! missing_letters_or_numbers?
    end

    def generate
      @words, count = [], word_count
      while count > 0
        next unless chars_processed?
        @words.push @alpha
        count -= 1
      end
      @words
    end
  end
end
