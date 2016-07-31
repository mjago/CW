require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestCurrentWord < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @word = CWG::CurrentWord.new
  end

  def teardown
    @word = nil
  end

  def test_initialize
    assert_equal '', @word.to_s
  end

  def test_current_word
  end

  def test_push_letter
    @word.push_letter 'a'
    assert_equal 'a', @word.to_s
    @word.push_letter '0'
    assert_equal 'a0', @word.to_s
  end

  def test_to_s
    @word.push_letter '-'
    assert_equal '-', @word.to_s
  end

  def test_clear
    @word.push_letter '.'
    assert_equal '.', @word.to_s
    @word.clear
    assert_equal '', @word.to_s
  end

  def test_strip
    @word.push_letter ' a '
    assert_equal ' a ', @word.to_s
    @word.strip
    assert_equal 'a', @word.to_s
  end

  def test_process_letter
    @word.process_letter 'A'
    assert_equal 'a', @word.to_s
    @word.process_letter 'z'
    assert_equal 'az', @word.to_s
    @word.process_letter ','
    assert_equal 'az,', @word.to_s
  end
end
