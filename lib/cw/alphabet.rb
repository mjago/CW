# encoding: utf-8

#class Alphabet provides alphabet generation functionality

class Alphabet

  # initialize class Alphabet
  # == Parameters:
  # options::
  #   An optional hash containg options:
  # :reverse - reverse alphabet
  # :shuffle - shuffle alphabet
  # :include - include only these letters of the alphabet
  # :exclude - exclude these letters from the alphabet

  def initialize(options = {})
    @options = options
  end

  # return string containing alphabet

  def alphabet
    'abcdefghijklmnopqrstuvwxyz'
  end

  # reverse alphabet if :reverse option defined

  def reverse_alphabet_maybe
    @letters.reverse! if @options[:reverse]
  end

  # shuffle alphabet if :shuffle option defined

  def shuffle_alphabet_maybe
    @letters = @letters.split('').shuffle.join if @options[:shuffle]
  end

  # include letters passed in as string if :include defined

  def include_letters
    if @options[:include]
      @letters = @options[:include]
    end
  end

  # exclude letters passed in as string if :exclude defined

  def exclude_letters
    if @options[:exclude]
      @letters.tr!(@options[:exclude],'')
    end
  end

  # generate alphabet with options acted upon
  # == Returns:
  # alphabet or filtered alphabet

  def generate
    @letters = alphabet
    include_letters
    exclude_letters
    shuffle_alphabet_maybe
    reverse_alphabet_maybe
    @letters.split('').join(' ')
  end
end
