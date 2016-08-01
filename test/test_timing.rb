require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestTiming < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @timing = CWG::Timing.new
  end

  def teardown
    @timing = nil
  end

  def test_attr_accessor_delay_time
    @timing.delay_time = 10
    assert_equal 10, @timing.delay_time
    @timing.delay_time = '10'
    assert_equal '10', @timing.delay_time
  end

  def test_attr_accessor_start_time
    @timing.start_time = 20
    assert_equal 20, @timing.start_time
    @timing.start_time = "text"
    assert_equal "text", @timing.start_time
  end

  def test_initialize_initializes_delay_time
    assert_equal 0.0, @timing.delay_time
  end

  def test_initialize_initializes_instance_of_CwEncoding
    assert_equal CWG::CwEncoding, @timing.instance_variable_get(:@cw_encoding).class
  end

  def test_cw_encoding_returns_an_encoding
    assert_equal [:dot, :dash], @timing.cw_encoding('a')
    assert_equal [:dash,:dash,:dot,:dot], @timing.cw_encoding('z')
  end

  def test_dot_returns_correct_wpm_timing_for_a_dot
    assert_equal 0.06, @timing.dot(20)
  end

  def test_dot_ms_returns_correct_ms_for_wpm
    @timing.instance_variable_set(:@wpm, 20)
    assert_equal 0.06, @timing.dot_ms
  end

  def test_init_print_words_timeout_sets_start_print_time
    time_now = Time.now
    @timing.init_print_words_timeout
    start_time = @timing.instance_variable_get(:@start_print_time)
    assert_in_delta time_now.to_i, start_time.to_i, 1
  end

  def test_init_print_words_timeout_sets_delay_print_time
    @timing.init_print_words_timeout
    assert_equal 2.0, @timing.instance_variable_get(:@delay_print_time)
  end

  def test_print_words_timeout
    @timing.instance_variable_set(:@start_print_time, Time.now)
    @timing.instance_variable_set(:@delay_print_time, 2.0)
    assert_equal false, @timing.print_words_timeout?
    @timing.instance_variable_set(:@start_print_time, Time.now - 3)
    @timing.instance_variable_set(:@delay_print_time, 2.0)
    assert_equal true, @timing.print_words_timeout?
  end

  def test_init_play_words_timeout_sets_start_play_time
    time_now = Time.now
    @timing.init_play_words_timeout
    start_time = @timing.instance_variable_get(:@start_play_time)
    assert_in_delta time_now.to_i, start_time.to_i, 1
  end

  def test_init_play_words_timeout_sets_delay_play_time
    @timing.init_play_words_timeout
    assert_equal 2.0, @timing.instance_variable_get(:@delay_play_time)
  end

  def test_play_words_timeout
    @timing.instance_variable_set(:@start_play_time, Time.now)
    @timing.instance_variable_set(:@delay_play_time, 1)
    assert_equal false, @timing.play_words_timeout?
    @timing.instance_variable_set(:@start_play_time, Time.now - 2)
    @timing.instance_variable_set(:@delay_play_time, 1)
    assert_equal true, @timing.play_words_timeout?
  end

  def test_effective_dot_ms
    @timing.instance_variable_set(:@effective_wpm, 20)
    assert_equal 0.06, @timing.effective_dot_ms
  end

  def test_init_char_timer
  end

  def test_init_char_timer_sets_start_time
    time_now = Time.now
    @timing.init_char_timer
    assert_in_delta time_now.to_i, @timing.start_time.to_i, 1
  end

  def test_init_char_timer_sets_delay_time
    @timing.init_char_timer
    assert_equal 0.0, @timing.delay_time
  end

  def test_char_delay_timeout
    @timing.start_time = Time.now
    @timing.delay_time = - 1.0
    assert_equal true, @timing.char_delay_timeout?
  end

  def test_char_delay_timeout_2
    @timing.start_time = Time.now
    @timing.delay_time = + 1.0
    assert_equal false, @timing.char_delay_timeout?
  end

  def test_char_timing_for_dot
    @timing.instance_variable_set(:@wpm, 20)
    assert_equal 0.06 + (0.06 * 3), @timing.char_timing([:dot])
  end

  def test_char_timing_for_dash
    @timing.instance_variable_set(:@wpm, 20)
    assert_equal 0.18 + (0.06 * 3), @timing.char_timing([:dash])
  end

  def test_char_timing_for_dash_dot
    @timing.instance_variable_set(:@wpm, 120)
    assert_equal 0.03 + 0.01 + (0.01 * 3) + (0.01 * 1), @timing.char_timing([:dash, :dot])
  end

  def test_code_space_timing_with_no_ewpm
    @timing.instance_variable_set(:@wpm, 20)
    assert_equal (0.06 * 3), @timing.code_space_timing
  end

  def test_code_space_timing_with_ewpm
    @timing.instance_variable_set(:@wpm, 20)
    @timing.instance_variable_set(:@effective_wpm, 10)
    assert_equal (0.12 * 3), @timing.code_space_timing
  end

  def test_space_timing_with_no_wpm
    @timing.instance_variable_set(:@wpm, 20)
    assert_equal (0.06 * 4), @timing.space_timing
  end

  def test_space_timing_with_wpm
    @timing.instance_variable_set(:@wpm, 20)
    @timing.instance_variable_set(:@effective_wpm, 10)
    assert_equal (0.12 * 4), @timing.space_timing
  end

  def test_char_delay_for_letter_e
    assert_equal(0.06 + (3 * 0.06), @timing.char_delay('e', 20, nil))
  end

  def test_char_delay_for_letter_t
    assert_equal((0.06 * 3) + (3 * 0.06), @timing.char_delay('t', 20, nil))
  end

  def test_char_delay_for_letter_i
    assert_equal( (( 2 * 0.06)) + (4 * 0.06), @timing.char_delay('i', 20, nil))
  end

  def test_char_delay_for_letter_m
    assert_equal( (( 2 * 0.18)) + (4 * 0.06), @timing.char_delay('m', 20, nil))
  end

  def test_char_delay_for_number_5
    assert_equal( (( 5 * 0.06)) + (7 * 0.06), @timing.char_delay('5', 20, nil))
  end

  def test_char_delay_for_number_0
    assert_equal( (( 5 * 0.18)) + (7 * 0.06), @timing.char_delay('0', 20, nil))
  end

  def test_char_delay_for_letter_e_with_ewpm
    assert_equal(0.06 + (3 * 0.12), @timing.char_delay('e', 20, 10))
  end

  def test_char_delay_for_letter_t_with_ewpm
    assert_equal((3 * 0.06) + (3 * 0.12), @timing.char_delay('t', 20, 10))
  end

  def test_char_delay_for_number_5_with_ewpm
    assert_equal( ((5 * 0.06) + (4 * 0.06)) + (3 * 0.12), @timing.char_delay('5', 20, 10))
  end

  def test_char_delay_for_number_0_with_ewpm
    assert_equal( ((5 * 0.18) + (4 * 0.06)) + (3 * 0.12), @timing.char_delay('0', 20, 10))
  end

  def test_append_char_delay_no_ewpm
    assert_equal(0, @timing.delay_time)
    @timing.append_char_delay('m', 20, nil)
    assert_equal( (( 2 * 0.18)) + (4 * 0.06), @timing.delay_time)
  end

  def test_append_char_delay_for_i_with_ewpm
    @timing.append_char_delay('i', 20, 10)
    assert_equal(( 2 * 0.06) + (1 * 0.06) + (3 * 0.12), @timing.delay_time)
  end

  def test_append_char_delay_for_m_with_ewpm
    @timing.append_char_delay('m', 20, 10)
    assert_equal((2 * 0.18) + (1 * 0.06) + (3 * 0.12), @timing.delay_time)
  end

end
