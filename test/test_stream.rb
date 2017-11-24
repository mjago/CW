require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw/element'
require_relative '../lib/cw/stream'

#  class TestStreamMatching < MiniTest::Test
#    def setup
#      @match = Match.new
#      @match.words = %w(here are some words and here are just a few more!)
#      @match.instance_variable_set :@words1,
#      %w(here are some words and here are just a few more!)
#    end
#
#    def test_StreamMatching_exists
#      assert_kind_of Match, @match
#    end
#
#    def test_next_returns_next_word
#      assert_equal 'here ', @match.next_word
#    end
#
#    def test_next_returns_next_word1
#      assert_equal 'here ', @match.next_word1
#    end
#
#    def test_load_words_loads_words_as_array_correctly
#      @match.load_words %w(here are some words and here are just a few more!)
#      assert_equal 'here', @match.words.first
#      assert_equal 'more!', @match.words.last
#    end
#
#    def test_remove_upto_match_removes_first_word_if_matched_word
#      assert_equal 'are some ', @match.remove_upto_match('here are some', 'here')
#    end
#
#    def test_truncate_actual_doesnt_generate_unnecessary_errors
#      @match.instance_variable_set :@actual_string, 'here are some'
#      @match.instance_variable_set :@attempt, 'here '
#      assert_equal 'are some ', @match.truncate_actual
#      assert_equal [], @match.instance_variable_get(:@errors)
#    end
#
#    def test_truncate_actual_generates_necessary_errors
#      @match.instance_variable_set :@actual_string, 'here are some'
#      @match.instance_variable_set :@attempt, 'are '
#      assert_equal 'some ', @match.truncate_actual
#      assert_equal ['here'], @match.instance_variable_get(:@errors)
#    end
#
#    def test_truncate_attempt
#      @match.instance_variable_set :@attempt, 'here '
#      assert_equal '', @match.truncate_attempt('here')
#    end
#
#    def test_have_actual_word_when_has_word
#      @match.instance_variable_set :@actual_string, 'have '
#      assert_equal true, @match.have_actual_word?
#    end
#
#    def test_have_attempt_word_when_has_word
#      @match.instance_variable_set :@attempt, 'have '
#      assert_equal true, @match.have_attempt_word?
#    end
#
#    def test_have_actual_word_when_havent_complete_word
#      @match.instance_variable_set :@actual_string, 'haven'
#      assert_equal false, @match.have_actual_word?
#    end
#
#    def test_have_attempt_word_when_havent_complete_word
#      @match.instance_variable_set :@attempt, 'haven'
#      assert_equal false, @match.have_attempt_word?
#    end
#
#    def test_actual_word_returns_first_complete_word
#      @match.instance_variable_set :@actual_string, 'one two three '
#      assert_equal 'one ', @match.actual_word
#    end
#
#    def test_attempt_word_returns_complete_word
#      @match.instance_variable_set :@attempt, 'one two three '
#      assert_equal 'one ', @match.attempt_word
#    end
#
#    def test_match_found_finds_match
#      @match.instance_variable_set :@actual_string, 'one two three '
#      assert_equal true, @match.match_found?('one ')
#    end
#
#    def test_match_found_refutes_invalid_match
#      @match.instance_variable_set :@actual_string, 'one two three '
#      assert_equal false, @match.match_found?('oxe ')
#    end
#
#    def test_mark_attempt
#      @match.instance_variable_set :@actual_string, 'one two three '
#      @match.instance_variable_set :@attempt, 'one  '
#      @match.mark_attempt
#      assert_equal 'two three ', @match.instance_variable_get(:@actual_string)
#      assert_equal '', @match.instance_variable_get(:@attempt)
#    end
#
#    def test_remove_upto_match_removes_first_2_words_if_matched_word_second
#      assert_equal 'some ', @match.remove_upto_match('here are some', 'are')
#    end
#
#    def test_remove_upto_match_removes_all_words_if_matched_word_last
#      assert_equal '', @match.remove_upto_match('here are some', 'some')
#    end
#
#    def test_enforce_max_word_lag_truncates_correctly
#      @match.instance_variable_set(:@actual_string, 'one two three four ')
#      @match.instance_variable_set(:@max_word_lag, 2)
#      assert_equal 'four ',  @match.enforce_max_word_lag
#
#      @match.instance_variable_set(:@actual_string, 'one two three four ')
#      @match.instance_variable_set(:@max_word_lag, 3)
#      assert_equal 'three four ',  @match.enforce_max_word_lag
#
#      @match.instance_variable_set(:@actual_string, 'one two three four ')
#      @match.instance_variable_set(:@max_word_lag, 4)
#      assert_equal 'two three four ',  @match.enforce_max_word_lag
#    end
#
#    def test_enforce_max_word_lag_returns_nil_where_truncation_unnecessary
#      @match.instance_variable_set(:@actual_string, 'one two three four ')
#      @match.instance_variable_set(:@max_word_lag, 5)
#      assert_nil @match.enforce_max_word_lag
#    end
#
#    def test_mark_attempt
#      @match.instance_variable_set(:@actual_string, 'one two three four ')
#      @match.instance_variable_set(:@attempt, 'one ')
#      @match.mark_attempt
#      assert_equal 'two three four ', @match.instance_variable_get(:@actual_string)
#
#    end
#  end

class TestStream < MiniTest::Test

  def setup
    @stream = CWG::Stream.new
  end

  def teardown
    @stream = nil
  end

  def test_assert
    assert true
  end

  def test_push_adds_to_the_stream
    @stream.push 'a'
    assert_equal({0 => 'a'}, @stream.stream)
    @stream.push 'tree'
    assert_equal({0 => 'a', 1 => 'tree'}, @stream.stream)
  end

  def test_count
    @stream.push 'a'
    assert_equal 1, @stream.count
    @stream.push 'tree'
    assert_equal 2, @stream.count
    assert_equal({0 => 'a', 1 => 'tree'}, @stream.stream)
  end

  def test_stream_element_can_be_marked_a_success
    @stream.push 'a'
    @stream.mark_success(0)
    assert_equal({0 => true}, @stream.instance_variable_get(:@success))
  end

  def test_stream_element_can_be_marked_a_fail
    @stream.push 'a'
    @stream.mark_success(0)
    @stream.push 'b'
    @stream.mark_fail(1)
    assert_equal({0 => true, 1 => false}, @stream.instance_variable_get(:@success))
  end

  def test_active_region_can_be_assigned
    @stream.active_region = 4
    assert_equal 4, @stream.active_region
  end

  def test_mark_inactive_region_fail_fails_unmarked_inactive_elements
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    @stream.active_region = 2
    @stream.fail_unmarked_inactive_elements
    assert_equal({0 => false, 1 => false, 2 => nil, 3 => nil}, @stream.instance_variable_get(:@success))
  end

  def test_mark_inactive_region_fail_doesnt_fail_successes
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    @stream.instance_variable_set(:@success, {0 => true, 1 => false})
    @stream.active_region = 2
    @stream.fail_unmarked_inactive_elements
    assert_equal({0 => true, 1 => false}, @stream.instance_variable_get(:@success))
  end

  def test_mark_inactive_region_fail_doesnt_fail_when_no_stream
    @stream.stream = {}
    @stream.fail_unmarked_inactive_elements
  end

  def test_first_returns_first_element_in_stream
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    assert_equal 'a', @stream.first
  end

  def test_pop_returns_first_element_in_stream_and_removes_element
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    assert_equal({:value => 'a', :success => false}, @stream.pop)
    refute(@stream.pop[:success])
    assert_equal({2 => 'c', 3 => 'd'}, @stream.stream)

    @stream.empty
    @stream.push 'a'
    refute(@stream.pop[:success])
    @stream.push 'b'
    refute(@stream.pop[:success])
    @stream.push 'c'
    refute(@stream.pop[:success])
    @stream.push 'd'
    refute(@stream.pop[:success])
    assert_nil @stream.pop
    assert_equal({}, @stream.stream)
  end

  def test_match_last_active_element_marks_correct_element
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    @stream.match_last_active_element('c')
    assert_equal({0 => false, 1 => false, 2 => true, 3 => nil}, @stream.instance_variable_get(:@success))
  end

  def test_match_last_active_element_doesnt_unmark_correct_element
    @stream.active_region = 2
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    @stream.match_last_active_element('c')
    @stream.match_last_active_element('d')
    assert_equal({0 => nil, 1 => false, 2 => true, 3 => true}, @stream.instance_variable_get(:@success))
  end

  def test_match_last_active_element_doesnt_unmark_failed_element
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    @stream.match_last_active_element('d')
    @stream.match_last_active_element('c')
    assert_equal({0 => false, 1 => false, 2 => true, 3 => true}, @stream.instance_variable_get(:@success))
  end

  #    def test_pop_marked_returns_nil_for_empty_stream
  #      assert_equal(nil, @stream.pop_marked)
  #      assert_equal(nil, @stream.pop_marked)
  #    end
  #
  #    def test_pop_marked_returns_up_to_marked_first_element
  #      @stream.push 'a'
  #      @stream.push 'b'
  #      @stream.push 'c'
  #      @stream.push 'd'
  #      @stream.match_last_active_element('a')
  #      assert_equal({0 => {'a' => true}}, @stream.pop_marked)
  #      assert_equal(nil, @stream.pop_marked)
  #    end
  #
  #    def test_pop_marked_returns_up_to_marked_second_element
  #      @stream.push 'a'
  #      @stream.push 'b'
  #      @stream.push 'c'
  #      @stream.push 'd'
  #      @stream.match_last_active_element('b')
  #      assert_equal({0 => {'a' => false}, 1 => {'b' => true}}, @stream.pop_marked)
  #      assert_equal(nil, @stream.pop_marked)
  #    end
  #
  #    def test_pop_marked_returns_up_to_marked_first_and_third_element
  #      @stream.push 'a'
  #      @stream.push 'b'
  #      @stream.push 'c'
  #      @stream.push 'd'
  #      @stream.match_last_active_element('a')
  #      @stream.match_last_active_element('c')
  #      assert_equal({0 => {'a' => true}, 1 => {'b' => false}, 2 => {'c' => true}}, @stream.pop_marked)
  #      assert_equal(nil, @stream.pop_marked)
  #      @stream.match_last_active_element('d')
  #      assert_equal({3 => {'d' => true}}, @stream.pop_marked)
  #    end
  #
  #    def test_pop_marked_returns_inactive_unmarked_elements
  #      @stream.push 'a'
  #      @stream.push 'b'
  #      @stream.push 'c'
  #      @stream.push 'd'
  #      @stream.active_region = 2
  #      assert_equal({0 => {'a' => false}, 1 => {'b' => false}}, @stream.pop_marked)
  #      assert_equal(nil, @stream.pop_marked)
  #      @stream.match_last_active_element('d')
  #      assert_equal({2 => {'c' => false}, 3 => {'d' => true}}, @stream.pop_marked)
  #    end
  #
  #    def test_pop_marked_returns_mix_of_active_and_inactive
  #      @stream.active_region = 2
  #      @stream.push 'a'
  #      @stream.push 'b'
  #      @stream.push 'c'
  #      @stream.push 'd'
  #      @stream.match_last_active_element('d')
  #      assert_equal({0 => {'a' => false}, 1 => {'b' => false}, 2 => {'c' => false}, 3 => {'d' => true}}, @stream.pop_marked)
  #      assert_equal(nil, @stream.pop_marked)
  #    end

  def test_pop_next_marked_returns_correct_elements_where_last_only_matched
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    @stream.match_last_active_element('d')
    refute(@stream.pop_next_marked[:success])
    refute(@stream.pop_next_marked[:success])
    refute(@stream.pop_next_marked[:success])
    assert(@stream.pop_next_marked[:success])
    assert_equal(nil, @stream.pop_next_marked)
  end

  def test_pop_next_marked_returns_correct_elements_where_penultimate_element_matched
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    @stream.match_last_active_element('c')
    assert_equal({:value => 'a', :success => false}, @stream.pop_next_marked)
    assert_equal({:value => 'b', :success => false}, @stream.pop_next_marked)
    assert_equal({:value => 'c', :success => true}, @stream.pop_next_marked)
    assert_equal(nil, @stream.pop_next_marked)
    assert_equal(nil, @stream.pop_next_marked)
  end

  def test_pop_next_marked_considers_active_region

    @stream.active_region = 2
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    assert_equal({:value => 'a', :success => false}, @stream.pop_next_marked)
    assert_equal({:value => 'b', :success => false}, @stream.pop_next_marked)
    assert_equal(nil, @stream.pop_next_marked)
    assert_equal(nil, @stream.pop_next_marked)

    @stream.empty
    @stream.active_region = 1
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    assert_equal({:value => 'a', :success => false}, @stream.pop_next_marked)
    assert_equal({:value => 'b', :success => false}, @stream.pop_next_marked)
    assert_equal({:value => 'c', :success => false}, @stream.pop_next_marked)
    assert_equal(nil, @stream.pop_next_marked)


    @stream.empty
    @stream.active_region = 2
    @stream.push 'a'
    @stream.push 'b'
    @stream.push 'c'
    @stream.push 'd'
    @stream.match_last_active_element('c')
    assert_equal({:value => 'a', :success => false}, @stream.pop_next_marked)
    assert_equal({:value => 'b', :success => false}, @stream.pop_next_marked)
    assert_equal({:value => 'c', :success => true}, @stream.pop_next_marked)
    assert_equal(nil, @stream.pop_next_marked)
    @stream.push 'e'
    @stream.push 'f'
    @stream.match_last_active_element('e')
    assert_equal({:value => 'd', :success => false}, @stream.pop_next_marked)
    assert_equal({:value => 'e', :success => true}, @stream.pop_next_marked)
    assert_equal(nil, @stream.pop_next_marked)
    assert_equal({5 => 'f'}, @stream.stream)
  end
end
