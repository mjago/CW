# encoding: utf-8

require_relative 'cw/version'
require_relative 'cw/file_details'
require_relative 'cw/process'
require_relative 'cw/cw_dsl'
require_relative 'cw/randomize'
require_relative 'cw/sentence'
require_relative 'cw/alphabet'
require_relative 'cw/numbers'
require_relative 'cw/str'
require_relative 'cw/rss'
require_relative 'cw/words'
require_relative 'cw/cl'
require_relative 'cw/cw_params'
require_relative 'cw/key_input'
require_relative 'cw/stream'
require_relative 'cw/timing'
require_relative 'cw/print'
require_relative 'cw/audio_player'
require_relative 'cw/cw_threads'
require_relative 'cw/book_details'
require_relative 'cw/tester'
require_relative 'cw/test_words'
require_relative 'cw/test_letters'
require_relative 'cw/repeat_word'
require_relative 'cw/book'
require_relative 'cw/cw_encoding'
require_relative 'cw/tone_generator.rb'
require_relative 'cw/progress'

# class CW provides Morse code generation functionality

class CW < CwDsl

  attr_accessor :dry_run
  attr_accessor :quit

  def test_letters
    @inhibit_block_run = true
    test_letters = TestLetters.new
    test_letters.run @words
  end

  def repeat_word
    @inhibit_block_run = true
    repeat_word = RepeatWord.new
    repeat_word.run @words
  end

  def initialize(&block)

    super

    load_common_words# unless @words.exist?
    instance_eval(&block) if block
    run unless Params.pause if (block && ! @inhibit_block_run)
  end

  def to_s
    @str.to_s
  end

  def run_word_test
    test_words = TestWords.new
    test_words.run @words
  end

  def test_words
    run_word_test
  end

  def play_book args = {}
    @inhibit_block_run = true
    details = BookDetails.new
    details.arguments(args)
    book = Book.new details
    book.run @words
  end

  def read_rss(source, show_count = 3)
    @inhibit_block_run = true
    rss, = Rss.new
    rss.read_rss(source, show_count)
    loop do
      article = rss.next_article
      return unless article
      test_words = TestWords.new
      @words.assign article
      test_words.run @words
    end
  end

  def run ; test_words ; end

  alias_method :ewpm,                  :effective_wpm
  alias_method :no_run,                :pause
  alias_method :comment,               :name
#  alias_method :repeat_word,           :double_words
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
