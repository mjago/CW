#class Alphabet provides alphabet generation functionality

class Alphabet

  def initialize(options = {})
    @options = options
  end

  def alphabet
    'abcdefghijklmnopqrstuvwxyz'
  end

  def reverse_alphabet_maybe
    @letters.reverse! if @options[:reverse]
  end

  def shuffle_alphabet_maybe
    @letters = @letters.split('').shuffle.join if @options[:shuffle]
  end

  def generate
    @letters = alphabet
    shuffle_alphabet_maybe
    reverse_alphabet_maybe
    @letters.split('').join(' ')
  end
end
