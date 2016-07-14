# encoding: utf-8

# class Cw_dsl provides CW's commands

require_relative 'params'

class CwDsl

  include Params::ParamsSetup

  attr_accessor :cl

  HERE = File.dirname(__FILE__) + '/'
  TEXT = HERE + '../../data/text/'
  COMMON_WORDS      = TEXT + 'common_words.txt'
  MOST_COMMON_WORDS = TEXT + 'most_common_words.txt'
  ABBREVIATIONS     = TEXT + 'abbreviations.txt'
  Q_CODES           = TEXT + 'q_codes.txt'

  def initialize
    @words, @cl, @str =
      Words.new, Cl.new, Str.new
    Params.init_config
    config_defaults
    config_files
  end

  def config_defaults
    Params.config {
      name           'unnamed'
      wpm            25
      frequency      500
      dictionary     COMMON_WORDS
    }
  end

  def config_files
    Params.config {
      audio_dir      'audio'
      audio_filename 'audio_output'
      word_filename  'words.txt'
    }
  end

  def words
    @words.all
  end

  def words= words
    @words.add words
  end

  def word_size(size = nil)
    if size
      Params.size = size
      @words.word_size size
    end
    Params.size
  end

  def word_count(wordcount)
    Params.word_count = wordcount
    @words.count wordcount
  end

  def beginning_with(* letters)
    @words.beginning_with letters
    Params.begin = letters
  end

  def ending_with(* letters)
    @words.ending_with letters
    Params.end = letters
  end

  def including(* letters)
    Params.including = letters
    @words.including letters
  end

  def containing(* letters)
    @words.containing letters
  end

  def double_words
    @words.double_words
  end

  def repeat mult
    @words.repeat mult
  end

  def no_longer_than(max)
    Params.max = max
    @words.no_longer_than max
  end

  def no_shorter_than(min)
    Params.min = min
    @words.no_shorter_than min
  end

  def reverse
    @words.reverse
  end

  def letters_numbers
    @words.letters_numbers
  end

  def random_letters_numbers(options = {})
    options.merge!(letters_numbers: true)
    @words.random_letters_numbers options
  end

  def random_letters(options = {})
    @words.random_letters(options)
  end

  def random_numbers(options = {})
    @words.random_numbers(options)
  end

  def alphabet(options = {reverse: nil})
    @words.alphabet(options)
  end

  def numbers(options = {reverse: nil})
    @words.numbers(options)
  end

  def numbers_spoken()
    #todo
  end

  #  def add_noise
  #    Params.noise = true
  #  end

  def reload
    load_words(Params.dictionary)
  end

  def load_common_words
    load_words
  end

  def load_most_common_words
    load_words MOST_COMMON_WORDS
  end

  def load_abbreviations
    load_words ABBREVIATIONS
  end

  def load_q_codes
    load_words Q_CODES
  end

  #todo refactor

  def alpha           ; 'a'.upto('z').collect{|ch| ch} ; end
  def vowels          ; ['a','e','i','o','u']          ; end
  def load_vowels     ; @words.assign vowels           ; end
  def load_alphabet   ; @words.assign alpha            ; end
  def load_consonants ; @words.assign alpha - vowels   ; end
  def numbers         ; '0'.upto('9').collect{|ch| ch} ; end
  def load_numbers    ; @words.assign numbers          ; end

  def load_words(filename = COMMON_WORDS)
    Params.dictionary = filename
    @words.load filename
  end

  def set_tone_type(type)
    case type
    when :squarewave, :sawtooth, :sinewave
      Params.tone = type
    end
  end

end
