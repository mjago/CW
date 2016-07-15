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
    load_common_words# unless @words.exist?
    ConfigFile.new.apply_config self
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

  # Test user against letters rather than words.
  #

  def test_letters
    Params.no_run = true
    test_letters = TestLetters.new
    test_letters.run @words
  end

  # Test user against complete words rather than letters.
  #

  def test_words
    Params.no_run = true
    tw = TestWords.new
    tw.run @words
  end

  # Repeat word repeats the current word if the word is entered incorrectly (or not entered at all).
  #

  def repeat_word
    Params.no_run = true
    repeat_word = RepeatWord.new
    repeat_word.run @words
  end

  # Reveal words only at end of test.
  # Useful for learning to copy `in the head'

  def reveal
    Params.no_run = true
    reveal = Reveal.new
    reveal.run @words
  end

  # Play book using provided arguments.
  # @param [Hash] args the options to play book with.
  # @option args [Integer] :sentences Number of sentences to play
  # @option args [Integer] :duration  Number of minutes to play
  # @option args [Boolean] :letter Mark by letter if true else mark by word

  def read_book args = {}
    Params.no_run = true
    details = BookDetails.new
    details.arguments(args)
    book = Book.new details
    book.run @words
  end

  # Convert book to mp3.

  def convert_book args = {}
    details = BookDetails.new
    details.arguments(args)
    book = Book.new details
    Params.no_run = true
    book.convert
  end

  # Reads RSS feed (requires an internet connection). Feed can be one of:
  # - bbc:
  # - reuters:
  # - guardian:
  # - quotation:
  # @param [Symbol] source The source of the feed.
  # @param [Integer] article_count Number of articles to play.

  def read_rss(source, article_count = 3)
    Params.no_run = true
    rss, = Rss.new
    rss.read_rss(source, article_count)
    loop do
      article = rss.next_article
      return unless article
      @words.assign article
      run
    end
  end

  def shuffle
    @words.shuffle
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

  # Return string containing name or comment of test.
  # @return [String] comment / name

  def to_s
    @str.to_s
  end

  def list
    Print.new.list self.to_s
    puts
  end

  def run_default
    Params.run_default ||= :test_letters
  end

  def run
    return if Params.no_run
    self.send run_default
  end

  alias_method :ewpm,                  :effective_wpm
  alias_method :comment,               :name
  alias_method :word_length,           :word_size
  alias_method :word_shuffle,          :shuffle
  alias_method :having_size_of,        :word_size
  alias_method :number_of_words,       :word_count
  alias_method :words_including,       :including
  alias_method :words_ending_with,     :ending_with
  alias_method :random_alphanumeric,   :random_letters_numbers
  alias_method :words_beginning_with,  :beginning_with
  alias_method :words_no_longer_than,  :no_longer_than
  alias_method :words_no_shorter_than, :no_shorter_than

end
