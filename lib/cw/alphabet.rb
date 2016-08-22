# encoding: utf-8

module CWG

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

    # alphabet()
    # Returns alphabet as string
    # == Parameters:
    # none

    def alphabet
      'abcdefghijklmnopqrstuvwxyz'
    end

    # reverse_alphabet_maybe()
    # reverse letters if reverse option set
    # == Parameters:
    # none

    def reverse_alphabet_maybe
      @letters.reverse! if @options[:reverse]
    end

    # shuffle_alphabet_maybe()
    # shuffle alphabet if :shuffle option defined
    # don't shuffle if in test environment
    # == Parameters:
    # none

    def shuffle_alphabet_maybe
      unless(ENV["CW_ENV"] == "test")
        @letters = @letters.split('').shuffle.join if @options[:shuffle]
      end
    end

    # include_letters()
    # include letters if :include option defined
    # == Parameters:
    # none

    def include_letters
      if @options[:include]
        @letters = @options[:include]
      end
    end

    # exclude_letters()
    # exclude letters if :exclude option defined
    # == Parameters:
    # none

    def exclude_letters
      if @options[:exclude]
        @letters.tr!(@options[:exclude],'')
      end
    end

    # generate()
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
end
