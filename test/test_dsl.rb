require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestNumbers < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @dsl = CW::Dsl.new
  end

  def teardown
    @dsl = nil
  end

  def test_words_returns_words
    words = @dsl.words
    assert words.is_a? Array
    assert_equal 1000, words.size
    assert_equal 'the', words.first
  end

  def test_load_common_words_returns_words
    words = @dsl.load_common_words
    assert words.is_a? Array
    assert_equal 1000, words.size
    assert_equal 'the', words.first
  end

  def test_most_load_most_common_words_returns_words
    words = @dsl.load_most_common_words
    assert words.is_a? Array
    assert_equal 500, words.size
    assert_equal 'the', words.first
  end

  def test_load_abbreviations
    words = @dsl.load_abbreviations
    assert words.is_a? Array
    assert_equal 85, words.size
    assert_equal 'abt', words.first
  end

  def test_reverse
    @dsl.words = %w[a b c]
    assert_equal CW::Dsl, @dsl.class
    @dsl.reverse
    assert_equal 'c', @dsl.words.first
  end

  def test_double_words
    @dsl.words = %w[a b]
    @dsl.double_words
    assert_equal %w[a a b b], @dsl.words
  end

  def test_letters_numbers
    assert_equal %w[a b c d e], @dsl.letters_numbers[0..4]
    assert_equal %w[y z], @dsl.words[24..25]
    assert_equal %w[0 1], @dsl.words[26..27]
    assert_equal %w[8 9], @dsl.words[34..35]
  end

  def test_random_numbers
    @dsl.random_numbers
    assert_equal Array, @dsl.words.class
    assert_equal 50, @dsl.words.size
    @dsl.words.each do |wrd|
      assert wrd.size == 4
      assert wrd.to_i > 0
      assert wrd.to_i < 10000
    end
  end

  def test_random_letters
    @dsl.random_letters
    assert_equal Array, @dsl.words.class
    assert_equal 50, @dsl.words.size
    @dsl.words.each do |wrd|
      assert wrd.size == 4
    end
  end

  def test_random_letters_numbers
    @dsl.random_letters_numbers
    assert_equal Array, @dsl.words.class
    assert_equal 50, @dsl.words.size
    @dsl.words.each do |wrd|
      assert wrd.size == 4
    end
  end

  def test_alphabet
    @dsl.alphabet
    assert_equal ["a b c d e f g h i j k l m n o p q r s t u v w x y z"], @dsl.words
  end

  def test_numbers
    assert_equal ['0', '1', '2', '3', '4'], @dsl.numbers[0..4]
  end
end
