require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestCore < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @cw = Core.new
    @cw.no_run
  end

  def teardown
    @cw = nil
  end

  def test_true
    assert true
  end

  def test_os_play_command
    obj = CWG::AudioPlayer.new
    assert ('afplay' == obj.os_play_command) || ('ossplay' == obj.os_play_command)
  end

  def test_cw_class
    assert_equal Core, @cw.class
  end

  def test_name_is_nil_if_unnamed
    refute @cw.name
  end

  def test_name_can_be_set
    @cw.name 'testing'
    assert_equal 'testing', @cw.name
  end

  def test_loads_words_by_default
    assert_equal %w(the of and to a), @cw.words.first(5)
  end

  def test_Core_takes_a_block
    Core.new {
      no_run
    }
  end

  def test_words_loads_words
    cw = Core.new {
      no_run
    }
    assert_equal 1000, cw.words.size
    cw.words = %w(some words)
    assert_equal %w(some words), cw.words
  end

  def test_no_run_aliases_no_run
    time = Time.now
    cw = Core.new {
      no_run
    }
    cw.words = %w(some words)
    assert (Time.now - time) < 1
  end

  def test_load_common_words_loads_common_words
    cw = Core.new {
      no_run
    }
    cw.words =  %w(some words)
    assert_equal  %w(some words), cw.words
    cw.load_common_words
    assert_equal  %w(the of and to a), cw.words.first(5)
  end

  def test_load_words_loads_passed_filename
    temp = Tempfile.new("words.tmp")
    temp << "some words"
    temp.close
    @cw.load_text temp
    assert_equal %w(some words), @cw.words
  end

   def test_to_s_outputs_test_run_header_if_no_run
     temp =
       %q(========
WPM:        25
Word count: 9999
========
)
     assert_equal temp, @cw.to_s
   end

  def test_to_s_outputs_relevant_params_if_set
    temp =
      %q(========
WPM:        25
Word count: 2
Word size:  3
Beginning:  l
Ending:     x
========
)
    @cw.word_count 2
    @cw.word_size 3
    @cw.ending_with('x')
    @cw.beginning_with('l')
    assert_equal temp, @cw.to_s
  end

  def test_wpm_defaults_to_25_if_unset
    assert_equal '25', @cw.wpm.to_s
  end

  def test_effective_wpm_defaults_to_nil
    assert_nil @cw.effective_wpm
  end

  def test_wpm_is_settable
    wpm = rand(50)
    @cw.wpm wpm
    assert_equal wpm, @cw.wpm
  end

  def test_effective_wpm_is_settable
    effective_wpm = rand(50)
    @cw.effective_wpm(effective_wpm)
    assert_equal(effective_wpm, @cw.effective_wpm)
  end

#todo  def test_word_spacing_is_settable_and_readable
#    word_spacing = rand(50)
#    @cw.word_spacing(word_spacing)
#    assert_equal(word_spacing, @cw.word_spacing)
#  end

  def test_shuffle_shuffles_words
    @cw.shuffle
    refute_equal  %w(the of and to a), @cw.words.first(5)
  end

  def test_word_size_returns_words_of_such_size
    @cw.word_size 2
    assert_equal  %w(of to in is on), @cw.words.first(5)
  end
  
  def test_beginning_with_returns_words_beginning_with_letter
    @cw.beginning_with 'l'
    assert_equal %w(like list last links life), @cw.words.first(5)
  end

  def test_beginning_with_will_take_two_letters
    @cw.load_words(1500)
    @cw.beginning_with 'x','q'
    assert_equal  %w(x xml quality questions q quote),
    @cw.words.first(6)
  end

  def test_ending_with_returns_words_ending_with_letter
    @cw.ending_with 'l'
    assert_equal %w(all will email well school), @cw.words.first(5)
  end

  def test_ending_with_will_take_two_letters
    @cw.load_words 200
    @cw.ending_with 'x', 'a'
    assert_equal %w(x sex a data),
    @cw.words
  end

  def test_word_count_returns_x_words
    @cw.word_count 3
    assert_equal ["the", "of", "and"] , @cw.words
  end

  def test_including_returns_words_including_letter
    @cw.including 'l'
    assert_equal %w(all will only also help), @cw.words.first(5)
  end

  def test_including_will_take_two_letters
    @cw.load_words(100)
    @cw.including 'p','b'
    assert_equal %w(page up help pm by be about but),@cw.words.first(8)
  end

  def test_no_longer_than_will_return_words_no_longer_than_x
    @cw.no_longer_than 4
    assert_equal %w(the of and to a), @cw.words.first(5)
  end

  def test_no_shorter_than_will_return_words_no_shorter_than_x
    @cw.no_shorter_than 4
    assert_equal %w(that this with from your), @cw.words.first(5)
  end

  def test_words_fn_adds_words
    @cw.words = "one two three four"
    assert_equal "one two three four", @cw.words
  end

  def test_words_fn_passes_in_an_array_of_words_as_is
    @cw.words = %w(one two three four)
    assert_equal  %w(one two three four), @cw.words
  end

  def test_random_letters_returns_words_of_size_4_by_default
    @cw.random_letters
    @cw.words.each { |w| assert_equal 4, w.length }
  end

  def test_random_letters_returns_word_count_of_50_by_default
    @cw.random_letters
    assert_equal 50, @cw.words.size
  end

  def test_random_letters_can_take_size_option
    @cw.random_letters(size: 5)
    @cw.words.each { |w| assert_equal 5, w.length }
  end

  def test_random_letters_can_take_count_option
    @cw.random_letters(count: 5)
    assert_equal 5, @cw.words.size
  end

  def test_random_letters_can_take_size_and_count_option
    @cw.random_letters(count: 3, size: 4)
    assert_equal 3, @cw.words.size
    @cw.words.each { |w| assert_equal 4, w.length }
  end

  def test_random_letters_returns_random_letters
    @cw.random_letters
    @cw.words.each { |w|
      assert_match(/^(?=.*\D)[-\w]+$/, w)
    }
  end

  def test_random_numbers_can_take_size_and_count_option
    @cw.random_numbers(count: 3, size: 4)
    assert_equal 3, @cw.words.size
    @cw.words.each { |w| assert_equal 4, w.length }
  end

  def test_random_numbers_returns_random_numbers
    @cw.random_numbers
    @cw.words.each { |w|
      assert_match(/\A[-+]?\d+\z/ , w)
    }
  end

  def test_random_letters_numbers_can_take_size_and_count_option
    @cw.random_letters_numbers(count: 3, size: 4)
    assert_equal 3, @cw.words.size
    @cw.words.each { |w|
      assert_equal 4, w.length
    }
  end

  def test_random_letters_numbers_includes_letter
    @cw.random_letters_numbers
    @cw.words.each { |w|
      assert_match( /[a-zA-Z]+/, w)
    }
  end

  def test_random_letters_numbers_includes_number
    @cw.random_letters_numbers
    @cw.words.each do |w|
      assert_match(/[0-9]+/, w)
    end
  end

  def test_alphabet_generates_alphabet
    @cw.alphabet
    assert_equal ['a b c d e f g h i j k l m n o p q r s t u v w x y z'], @cw.words
  end

  def test_alphabet_generates_reversed_alphabet
    @cw.alphabet(reverse: true)
    assert_equal ['z y x w v u t s r q p o n m l k j i h g f e d c b a'], @cw.words
  end

  def test_alphabet_shuffles_alphabet
    @cw.alphabet(shuffle: true)
    refute_equal ['a b c d e f g h i j k l m n o p q r s t u v w x y z'], @cw.words
    assert_equal "abcdefghijklmnopqrstuvwxyz", @cw.words.first.chars.sort.join.strip
  end

  def test_reverse_reverses_words
    @cw.words = 'first then last'
    @cw.reverse
    assert_equal 'tsal neht tsrif', @cw.words
  end

  #FIXME
  #      def test_convert_generates_correct_command_for_default
  #        @cw.dry_run = true
  #        @cw.words = "some words"
  #        assert_equal "echo some words | ebook2cw -w 25 -o \"mp3_output\" ", @cw.convert
  #      end

  #     def test_run_converts_and_plays
  #       @cw.dry_run = true
  #       @cw.words = ["some", "words"]
  #       assert_equal 'played', @cw.run
  #     end

  def test_frequency_returns_frequency
    assert_equal 567, @cw.frequency(567)
    @cw.frequency 456
    assert_equal 456, @cw.frequency
    end

  def test_play_command_returns_play_command
    assert_equal 567, @cw.play_command(567)
    @cw.play_command 456
    assert_equal 456, @cw.play_command
  end

  #todo
  #  def test_play_builds_correct_command_for_default
  #    @cw.words = "some words"
  #    @cw.dry_run = true
  #    assert_equal "afplay mp3_output0000.mp3", @cw.play
  #  end

  #todo
  ##  def test_dot_ms_returns_correct_time_in_milliseconds
  ##    assert_in_delta(0.1, @cw.dot_ms(12), 0.001)
  ##  end
  ##
  ##  def test_space_ms_returns_correct_time_in_milliseconds
  ##    assert_in_delta(0.3, @cw.space_ms(12), 0.001)
  ##  end

  def test_method_aliases
    assert @cw.method(:word_length),           @cw.method(:word_size)
    assert @cw.method(:having_size_of),        @cw.method(:word_size)
    assert @cw.method(:word_shuffle),          @cw.method(:shuffle)
    assert @cw.method(:words_beginning_with),  @cw.method(:beginning_with)
    assert @cw.method(:words_ending_with),     @cw.method(:ending_with)
    assert @cw.method(:number_of_words),       @cw.method(:word_count)
    assert @cw.method(:words_including),       @cw.method(:including)
    assert @cw.method(:words_no_longer_than),  @cw.method(:no_longer_than)
    assert @cw.method(:words_no_shorter_than), @cw.method(:no_shorter_than)
    assert @cw.method(:random_alphanumeric),   @cw.method(:random_letters_numbers)
    assert @cw.method(:comment),               @cw.method(:name)
    assert @cw.method(:comment),               @cw.method(:name)
  end

  def test_set_wpm_param
    @cw.wpm 35
    assert_equal 35, @cw.wpm
    assert @cw.instance_variable_get('@cl').cl_wpm == '-w 35 ', 'wpm param invalid'
  end

  def test_set_ewpm_param
    @cw.effective_wpm 33
    assert @cw.instance_variable_get('@cl').cl_effective_wpm == '-e 33 ', 'effective_wpm param invalid'
  end

  def test_set_word_spacing_W_param
    @cw.word_spacing 2
    assert @cw.instance_variable_get('@cl').cl_word_spacing == '-W 2 ', 'word_spacing param invalid'
  end

  def test_set_freq_f_param
    @cw.frequency 800
    assert @cw.instance_variable_get('@cl').cl_frequency == '-f 800 ', 'frequency param invalid'
  end

  def test_tone_squarewave_param
    @cw.tone :squarewave
    assert @cw.instance_variable_get('@cl').cl_squarewave == '-T 2 ', 'squarewave param invalid'
  end

  def test_tone_sawtooth_param
    @cw.tone :sawtooth
    assert @cw.instance_variable_get('@cl').cl_sawtooth == '-T 1 ', 'sawtooth param invalid'
  end

  def test_tone_sinewave_param
    @cw.tone :sinewave
    assert @cw.instance_variable_get('@cl').cl_sinewave == '-T 0 ', 'sinewave param invalid'
  end

  def test_build_build_cl_ignores_invalid_tone_type
    @cw.tone :invalid
    assert @cw.instance_variable_get('@cl').cl_sinewave == '', 'not ignoring invalid tone type'
  end

  def test_set_author_param
    @cw.author 'some author'
    assert @cw.instance_variable_get('@cl').cl_author == '-a "some author" ', 'author param invalid'
  end

  def test_set_title_param
    @cw.title 'some title'
    assert @cw.instance_variable_get('@cl').cl_title == '-t "some title" ', 'title param invalid'
  end

  def test_set_N_param_in_noise_mode
    @cw.noise
    assert @cw.instance_variable_get('@cl').cl_noise.include?('-N 10 '), 'noise N param invalid'
  end

  def test_set_B_param_in_noise_mode
    @cw.noise
    assert @cw.instance_variable_get('@cl').cl_noise.include?('-B 800 '), 'noise B param invalid'
  end

#  def test_set_default_filename
#    assert @cw.instance_variable_get('@cl').cl_audio_filename.
#      include?('audio_output'), 'default audio output filename invalid'
#  end

  def test_set_audio_filename_to_given_name
    @cw.audio_filename('some name')
    assert @cw.instance_variable_get('@cl').cl_audio_filename.
      include?("some name"), 'default audio filename invalid'
  end

  def test_set_q_param_when_numeric_quality
    @cw.quality 5
    assert @cw.instance_variable_get('@cl').cl_quality.
      include?('-q 5 '), 'audio quality invalid'
  end

  def test_set_low_quality
    @cw.quality :low
    assert @cw.instance_variable_get('@cl').cl_quality.
      include?('-q 9 '), 'audio low quality invalid'
  end

  def test_set_medium_quality
    @cw.quality :medium
    assert @cw.instance_variable_get('@cl').cl_quality.
      include?('-q 5 '), 'audio medium quality invalid'
  end

  def test_set_high_quality
    @cw.quality :high
    assert @cw.instance_variable_get('@cl').cl_quality.
      include?('-q 1 '), 'audio high quality invalid'
  end

  def test_build_command_includes_custom_commands_via_build_cl
    @cw.command_line '-x "some custom command"'
    assert @cw.instance_variable_get('@cl').cl_command_line.
      include?( '-x "some custom command"'), 'custom command invalid'
  end

#  def test_cl_echo_returns_correct_string
#    str = ''
#    Core.new do
#      str = @cl.cl_echo('some words')
#      no_run
#    end
#    assert str.include?('some words')
#  end

  def test_words_exist
    temp = nil
    Core.new do
      words = 'some words added here'
      temp = words
      no_run
    end
    assert_equal(4, temp.split.size)
    Core.new do
      @words.add 'a couple of words'
      temp = words
      no_run
    end
    assert_equal(4, temp.split.size)
    Core.new do
      @words.add nil
      temp = words
      no_run
    end
    assert_nil(temp)
  end
end
