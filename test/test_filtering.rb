require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestCW < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @cw = CW.new
    @cw.pause
  end

  def teardown
    @cw = nil
  end

  def test_something
    assert true
  end

  def test_beginning_with_a
    @cw.words = ['able', 'zero']
    @cw.beginning_with('a')
    assert_equal ['able'], @cw.words
  end

  def test_beginning_with_z
    @cw.words = ['able', 'zero']
    @cw.beginning_with('z')
    assert_equal ['zero'], @cw.words
  end

  def test_beginning_with_ab
    @cw.words = ['ardvark', 'able', 'zero']
    @cw.beginning_with('ab')
    assert_equal ['able'], @cw.words
  end

  def test_beginning_with_range
    @cw.words = ['able', 'delta', 'zero']
    @cw.beginning_with('a'..'d')
    assert_equal ['able', 'delta'], @cw.words
  end

  def test_beginning_with_with_no_match
    @cw.words = ['able', 'zero']
    @cw.beginning_with('b')
    assert_equal [], @cw.words
  end

  def test_beginning_with_with_empty_string_returns_all
    @cw.words = ['able', 'zero']
    @cw.beginning_with('')
    assert_equal ['able', 'zero'], @cw.words
  end

  def test_ending_with_a
    @cw.words = ['else', 'antenna', 'alba', 'zero']
    @cw.ending_with('a')
    assert_equal ['antenna', 'alba'], @cw.words
  end

  def test_ending_with_z
    @cw.words = ['joy', 'pazazz']
    @cw.ending_with('z')
    assert_equal ['pazazz'], @cw.words
  end

  def test_ending_with_tion
    @cw.words = ['tiona', 'lion', 'station', 'creation']
    @cw.ending_with('tion')
    assert_equal ['station', 'creation'], @cw.words
  end

  def test_ending_with_range
    @cw.words = ['may', 'kay', 'yam', 'eye', 'pizazz']
    @cw.ending_with('y'..'z')
    assert_equal ['may', 'kay', 'pizazz'], @cw.words
  end

  def test_ending_with_with_no_match
    @cw.words = ['able', 'zero']
    @cw.ending_with('b')
    assert_equal [], @cw.words
  end

  def test_ending_with_with_empty_string_returns_all
    @cw.words = ['able', 'zero']
    @cw.ending_with('')
    assert_equal ['able', 'zero'], @cw.words
  end

  def test_including_a
    @cw.words = ['else', 'banter', 'alt', 'zero']
    @cw.including('a')
    assert_equal ['banter', 'alt'], @cw.words
  end

  def test_including_z
    @cw.words = ['joy', 'amaze', '123']
    @cw.including('z')
    assert_equal ['amaze'], @cw.words
  end

  def test_including_tion
    @cw.words = ['tiona', 'lion', 'station', 'creation']
    @cw.including('tion')
    assert_equal ['tiona', 'station', 'creation'], @cw.words
  end

  def test_including_range
    @cw.words = ['may', 'kay', 'yam', 'eye', 'pizazz']
    @cw.including('g'..'k')
    assert_equal ['pizazz', 'kay'], @cw.words
  end

  def test_including_with_no_match
    @cw.words = ['able', 'zero']
    @cw.including('c')
    assert_equal [], @cw.words
  end

  def test_including_with_empty_string_returns_all
    @cw.words = ['able', 'zero']
    @cw.including('')
    assert_equal ['able', 'zero'], @cw.words
  end

  def test_no_longer_than_1
    @cw.words = ['1', '12', '123']
    @cw.no_longer_than(1)
    assert_equal ['1'], @cw.words
  end

  def test_no_longer_than_2
    @cw.words = ['1', '12', '123']
    @cw.no_longer_than(2)
    assert_equal ['1', '12'], @cw.words
  end

  def test_no_longer_than_with_no_match
    @cw.words = ['123', '1234', '12345']
    @cw.no_longer_than(2)
    assert_equal [], @cw.words
  end

  def test_no_longer_than_0
    @cw.words = ['1', '12', '123']
    @cw.no_longer_than(0)
    assert_equal [], @cw.words
  end

  def test_no_shorter_than_1
    @cw.words = ['1', '12', '123']
    @cw.no_shorter_than(1)
    assert_equal ['1', '12', '123'], @cw.words
  end

  def test_no_shorter_than_2
    @cw.words = ['1', '12', '123']
    @cw.no_shorter_than(2)
    assert_equal ['12', '123'], @cw.words
  end

  def test_no_shorter_than_3
    @cw.words = ['1', '12', '123']
    @cw.no_shorter_than(3)
    assert_equal ['123'], @cw.words
  end

  def test_no_shorter_than_with_no_match
    @cw.words = ['123', '1234', '12345']
    @cw.no_shorter_than(4)
    assert_equal ['1234', '12345'], @cw.words
  end

  def test_no_shorter_than_0
    @cw.words = ['1', '12', '123']
    @cw.no_shorter_than(0)
    assert_equal ['1', '12', '123'], @cw.words
  end

  def test_double_words
    @cw.words = ['1', '12', '123']
    @cw.double_words
    assert_equal ['1', '1', '12', '12', '123', '123'], @cw.words
  end

  def test_repeat_once
    @cw.words = ['1', '12', '123']
    @cw.repeat 1
    assert_equal ['1', '12', '123', '1', '12', '123'], @cw.words
  end

  def test_repeat_twice
    @cw.words = ['1', '12', '123']
    @cw.repeat 2
    assert_equal ['1', '12', '123', '1', '12', '123', '1', '12', '123'], @cw.words
  end
  def test_repeat_none
    @cw.words = ['1', '12', '123']
    @cw.repeat 0
    assert_equal ['1', '12', '123'], @cw.words
  end

  def test_word_size_1
    @cw.words = ['1', '12', '123']
    @cw.word_size 1
    assert_equal ['1'], @cw.words
  end

  def test_word_size_2
    @cw.words = ['1', '12', '23', '123']
    @cw.word_size 2
    assert_equal ['12','23'], @cw.words
  end

  def test_word_size_3
    @cw.words = ['1', '12', '23', '123']
    @cw.word_size 3
    assert_equal ['123'], @cw.words
  end

  def test_containing_abc
    @cw.words = ['abd', 'abc', 'acb', 'cba', '123', 'ab', 'ad', 'cb']
    @cw.containing ['a','b','c']
    assert_equal ['abc', 'acb', 'cba', 'ab', 'cb'], @cw.words
  end

  def test_containing_with_range
    @cw.words = ['abd', 'abc', 'acb', 'cba', '123', 'ab', 'ad', 'cb']
    @cw.containing ['a'..'c']
    assert_equal ['abc', 'acb', 'cba', 'ab', 'cb'], @cw.words
  end
end

