class CurrentWord

  def initialize
    @current_word = ''
  end

  def current_word
    @current_word ||= String.new
  end

  def push_letter letr
    @current_word += letr
  end

  def to_s
    @current_word
  end

  def clear
    @current_word.clear
    @current_word = ''
  end

  def strip
    @current_word.strip!
  end

  def process_letter letr
    letr.downcase!
    push_letter letr
  end

end

#class Words deals with words

class Words

  def load(filename)
    File.open(filename, 'r') do |file|
      @words = file.read.split
    end
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

  def beginning_with(* letters)
    @words = letters.flatten.collect{|letr| beginning_with_letter(letr)}.flatten
  end

  def ending_with_letter(letr)
    @words.select{|wrd| wrd.end_with?(letr)}
  end

  def ending_with(* letters)
    @words = letters.flatten.collect{|letr| ending_with_letter(letr)}.flatten
  end

  def count word_count
    @words = @words.take(word_count)
  end

  def including_letter(letr)
    @words.select{|wrd| wrd.include?(letr)}
  end

  def including(* letters)
    @words = letters.flatten.collect{|letr| including_letter(letr)}.flatten
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

  def letters
    (97..122).to_a
  end

  def numbers
    (48..57).to_a
  end

  def letters_numbers
    letters.push( * numbers)
  end

  def random_letters(options = {})
    @words = Randomize.new(options, letters).generate
  end

  def random_numbers(options = {})
    @words = Randomize.new(options, numbers).generate
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

end
