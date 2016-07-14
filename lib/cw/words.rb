# encoding: utf-8

#class Words deals with words

class Words

  include TextHelpers

  def load(filename)
    File.open(filename, 'r') do |file|
      @words = file.read.split
    end
  end

  def double_words
    temp = []
    @words.each do |wrd|
      2.times { temp.push wrd }
    end
    @words = temp
  end

  def shuffle
    @words.shuffle!
  end

  def to_array
    @words
  end

  def all
    @words
  end

  def to_s
    @words.join(' ')
  end

  def add words
    @words = words
  end

  def exist?
    @words
  end

  def word_size(size)
    @words = @words.select{|wrd| wrd.size == size}
  end

  def beginning_with_letter(letr)
    @words.select{|wrd| wrd.start_with?(letr)}
  end

  def ending_with_letter(letr)
    @words.select{|wrd| wrd.end_with?(letr)}
  end

  def beginning_with(* letters)
    letter_filter(:beginning_with, letters)
  end

  def ending_with(* letters)
    letter_filter(:ending_with, letters)
  end

  def including(* letters)
    letter_filter(:including, letters)
  end

  def letter_filter(option,letters)
    method_name = option.to_s + "_letter"
    @words = letters.flatten.collect do |letr|
      if letr.class == Range
        letr.collect do |let|
          self.send(method_name, let)
        end
      else
          self.send(method_name, letr)
      end
    end.flatten
  end

  def count word_count
    @words = @words.take(word_count)
  end

  def including_letter(letr)
    @words.select{|wrd| wrd.include?(letr)}
  end

  def containing(* letters)
    lets = letters.flatten.join('').split("")
    found, temp, @words = false, @words, []
    temp.each do |wrd|
      wrd_lets = wrd.split("")
      wrd_lets.each do |wrd_let|
        if lets.include?(wrd_let)
          found = true
        else
          found = false
          break
        end
      end
      if found
        @words.push wrd
      end
    end
    @words
  end

  def no_longer_than(max)
    @words = @words.select{|wrd| wrd.size <= max}
  end

  def no_shorter_than(min)
    @words = @words.select{|wrd| wrd.size >= min}
  end

  def assign(words)
    words.kind_of?(String) ?
    @words = words.split(/\s+/) :
      @words = words
  end

  def collect_words
    @words.each{ |word| ' ' + word }.
      collect{|wrd| wrd}.join(' ')
  end

  def reverse
    @words.reverse!
  end

  def letters_numbers
    letter_group.push( * number_group)
  end

  def random_letters(options = {})
    @words = Randomize.new(options, letter_group).generate
  end

  def random_numbers(options = {})
    @words = Randomize.new(options, number_group).generate
  end

  def random_letters_numbers(options = {})
    @words = Randomize.new(options, letters_numbers.shuffle).generate
  end

  def alphabet(options = {reverse: nil})
    @words = [Alphabet.new(options).generate]
  end

  def numbers(options = {reverse: nil})
    @words = [Numbers.new(options).generate]
  end

  def numbers_spoken()

  end
end
