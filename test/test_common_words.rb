require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestCommonWords < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @words = CWG::CommonWords.new
  end

  def teardown
    @words = nil
  end

  def test_parse_quantity_for_1
    assert_equal [0], @words.parse_quantity(1)
  end

  def test_parse_quantity_for_2
    assert_equal [0,1], @words.parse_quantity(2)
  end

  def test_parse_quantity_for_range_1_2
    assert_equal [0,1], @words.parse_quantity(1..2)
  end

  def test_parse_quantity_for_range_2_3
    assert_equal [1,2], @words.parse_quantity(2..3)
  end

  def test_parse_quantity_for_no_argument
    assert_equal [0, 999], @words.parse_quantity()
  end

  def test_read_returns_the_with_argument_1
    assert_equal ['the'], @words.read(1)
  end

  def test_read_returns_the_with_argument_2
    assert_equal ['the','of'], @words.read(2)
  end

  def test_read_returns_the_with_range_2_3
    assert_equal ['of','and'], @words.read(2..3)
  end

  def test_read_returns_100_words_for_no_argument
    assert_equal 1000, @words.read().size
  end

  def test_read_returns_500_words_for_range_100_to_1600
    words = @words.read(100...1600)
    assert_equal 1500, words.size
    assert_equal 'find',words[0]
    assert_equal 'phentermine',words[-1]
  end

  def test_all_returns_all_words
    words = @words.read(:all)
    assert_equal 10000, words.size
    assert_equal 'the',words[0]
    assert_equal 'poison',words[-1]
  end

end
