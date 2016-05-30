require 'simplecov'

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

  def test_true
    assert true
  end

  def test_cw_class
    assert_equal CW, @cw.class
  end

  def test_name_is_unnamed_if_unnamed
    assert_equal 'unnamed', @cw.name
  end

  def test_name_can_be_set
    @cw.name 'testing'
    assert_equal 'testing', @cw.name
  end

  def test_loads_words_by_default
    assert_equal ["the", "of", "and", "a", "to"] , @cw.words.first(5)
  end

  def test_dictionary_defaults_to_COMMON_WORDS
    temp = nil
    CW.new {
      pause
      temp = Params.dictionary
    }
    assert_equal File.expand_path(ROOT + '/data/text/common_words.txt'), File.expand_path(temp)
  end

  def test_CW_takes_a_block
    CW.new {
      pause
    }
  end

  def test_dont_load_common_words_if_passed_in_block
    cw = CW.new {
      pause
    }
    cw.words = ["some", "words"]
    assert_equal ["some", "words"], cw.words
  end

  def test_word_filename_defaults_to_words
    cw = CW.new {
      pause
    }
    cw.words = ["some", "words"]
    assert_equal ["some","words"], cw.words
  end

  def test_no_run_aliases_pause
    time = Time.now
    cw = CW.new {
      no_run
    }
    cw.words = ["some", " words"]
    assert (Time.now - time) < 1
  end

  def test_default_mp3_filename_is_mp3_output
    temp = nil
    cw = CW.new {
      no_run
      temp = Params.audio_filename
    }
    assert_equal "audio_output.wav", temp
  end

  def test_reload_reloads_dictionary
    cw = CW.new {
      pause
    }
    cw.words = ["some", "words"]
    assert_equal ["some", "words"], cw.words
    cw.reload
    assert_equal ["the", "of", "and", "a", "to"] , cw.words.first(5)
  end

  def test_load_common_words_loads_common_words
    cw = CW.new {
      pause
    }
    cw.words = ["some", "words"]
    assert_equal ["some", "words"], cw.words
    cw.load_common_words
    assert_equal ["the", "of", "and", "a", "to"] , cw.words.first(5)
  end

  def test_load_words_loads_passed_filename
    temp = Tempfile.new("words.tmp")
    temp << "some words"
    temp.close
    @cw.load_words(temp)
    assert_equal ["some", "words"], @cw.words
  end

  def test_reload_reuploads_new_words_ie_dictionary_updated
    temp = Tempfile.new("words.tmp")
    temp << "some more words"
    temp.close
    @cw.load_words(temp)
    assert_equal ["some", "more", "words"], @cw.words
    @cw.words = ''
    @cw.reload
    assert_equal ["some", "more", "words"], @cw.words
    @cw.load_common_words
    assert_equal ["the", "of", "and", "a", "to"] , @cw.words.first(5)
  end

   def test_to_s_outputs_test_run_header_if_paused
     temp =
       %q(unnamed
=======
WPM:        25
=======
)
     assert_equal temp, @cw.to_s
   end

  def test_to_s_outputs_relevant_params_if_set
    temp =
      %q(unnamed
=======
WPM:        25
Shuffle:    yes
Word count: 2
Word size:  3
Beginning:  l
Ending:     x
=======
)
    @cw.shuffle
    @cw.word_count 2
    @cw.word_size 3
    @cw.ending_with('x')
    @cw.beginning_with('l')
    assert_equal temp, @cw.to_s
  end

  def test_wpm_defaults_to_25_if_unset
    assert_equal 25, @cw.wpm
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
    @cw.effective_wpm effective_wpm
    assert_equal effective_wpm, @cw.effective_wpm
  end

  def test_word_spacing_is_settable_and_readable
    word_spacing = rand(50)
    @cw.word_spacing word_spacing
    assert_equal word_spacing, @cw.word_spacing
  end

  def test_shuffle_shuffles_words
    @cw.shuffle
    refute_equal ["the", "of", "and", "a", "to"] , @cw.words.first(5)
  end

  def test_no_shuffle_doesnt_shuffle
    @cw.no_shuffle
    assert_equal ["the", "of", "and", "a", "to"] , @cw.words.first(5)
  end

  def test_word_size_returns_words_of_such_size
    @cw.word_size 2
    assert_equal ["of", "to", "in", "is", "it"] , @cw.words.first(5)
  end
  
  def test_beginning_with_returns_words_beginning_with_letter
    @cw.beginning_with 'l'
    assert_equal ["like", "look", "long", "little", "large"] , @cw.words.first(5)
  end

  def test_beginning_with_will_take_two_letters
    @cw.beginning_with 'q','b'
    assert_equal ["question", "quickly", "quite", "quiet", "be", "by"] ,
    @cw.words.first(6)
  end

  def test_ending_with_returns_words_ending_with_letter
    @cw.ending_with 'l'
    assert_equal ["all", "will", "call", "oil", "well"] , @cw.words.first(5)
  end

  def test_ending_with_will_take_two_letters
    @cw.ending_with 'x', 'a'
    assert_equal ["box", "six", "suffix", "a", "America", "sea"] ,
    @cw.words.first(6)
  end

  def test_word_count_returns_x_words
    @cw.word_count 3
    assert_equal ["the", "of", "and"] , @cw.words
  end

  def test_including_returns_words_including_letter
    @cw.including 'l'
    assert_equal ["all", "will", "would", "like", "look"] , @cw.words.first(5)
  end

  def test_including_will_take_two_letters
    @cw.including 'q', 'a'
    assert_equal ["question", "quickly", "equation", "square", "quite", "quiet", "equal", "and"] ,@cw.words.first(8)
  end

  def test_no_longer_than_will_return_words_no_longer_than_x
    @cw.no_longer_than 4
    assert_equal ["the", "of", "and", "a", "to"] , @cw.words.first(5)
  end

  def test_no_shorter_than_will_return_words_no_shorter_than_x
    @cw.no_shorter_than 4
    assert_equal ["that", "with", "they", "this", "have"] , @cw.words.first(5)
  end

  def test_words_fn_adds_words
    @cw.words = "one two three four"
    assert_equal "one two three four", @cw.words
  end

  def test_words_fn_passes_in_an_array_of_words_as_is
    @cw.words = ["one", "two", "three", "four"]
    assert_equal ["one", "two", "three", "four"] , @cw.words
  end

  def test_random_letters_returns_words_of_size_4_by_default
    @cw.random_letters
    @cw.words.each { |w| assert_equal 4, w.length}
  end

  def test_random_letters_returns_word_count_of_50_by_default
    @cw.random_letters
    assert_equal 50, @cw.words.size
  end

  def test_random_letters_can_take_size_option
    @cw.random_letters(size: 5)
    @cw.words.each { |w| assert_equal 5, w.length}
  end

  def test_random_letters_can_take_count_option
    @cw.random_letters(count: 5)
    assert_equal 5, @cw.words.size
  end

  def test_random_letters_can_take_size_and_count_option
    @cw.random_letters(count: 3, size: 4)
    assert_equal 3, @cw.words.size
    @cw.words.each { |w| assert_equal 4, w.length}
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
    @cw.words.each { |w| assert_equal 4, w.length}
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
    assert_equal ["a b c d e f g h i j k l m n o p q r s t u v w x y z"], @cw.words
  end

  def test_alphabet_generates_reversed_alphabet
    @cw.alphabet(reverse: true)
    assert_equal ['z y x w v u t s r q p o n m l k j i h g f e d c b a'], @cw.words
  end

  def test_alphabet_shuffles_alphabet
    @cw.alphabet(shuffle: true)
    refute_equal ["a b c d e f g h i j k l m n o p q r s t u v w x y z"], @cw.words
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
    assert @cw.method(:no_run),                @cw.method(:pause)
  end

  def test_set_wpm_param
    @cw.wpm 33
    assert @cw.cl.cl_wpm == '-w 33 ', 'wpm param invalid'
  end

  def test_set_ewpm_param
    @cw.effective_wpm 33
    assert @cw.cl.cl_effective_wpm == '-e 33 ', 'effective_wpm param invalid'
  end

  def test_set_word_spacing_W_param
    @cw.word_spacing 2
    assert @cw.cl.cl_word_spacing == '-W 2 ', 'word_spacing param invalid'
  end

  def test_set_freq_f_param
    @cw.frequency 800
    assert @cw.cl.cl_frequency == '-f 800 ', 'frequency param invalid'
  end

  def test_set_squarewave_param
    @cw.set_tone_type :squarewave
    assert @cw.cl.cl_squarewave == '-T 2 ', 'squarewave param invalid'
  end

  def test_set_sawtooth_param
    @cw.set_tone_type :sawtooth
    assert @cw.cl.cl_sawtooth == '-T 1 ', 'sawtooth param invalid'
  end

  def test_set_sinewave_param
    @cw.set_tone_type :sinewave
    assert @cw.cl.cl_sinewave == '-T 0 ', 'sinewave param invalid'
  end

  def test_build_build_cl_ignores_invalid_tone_type
    @cw.set_tone_type :sinewave
    @cw.set_tone_type :invalid
    assert @cw.cl.cl_sinewave == '-T 0 ', 'not ignoring invalid tone type'
  end

  def test_set_author_param
    @cw.author 'some author'
    assert @cw.cl.cl_author == '-a "some author" ', 'author param invalid'
  end

  def test_set_title_param
    @cw.title 'some title'
    assert @cw.cl.cl_title == '-t "some title" ', 'title param invalid'
  end

  def test_set_N_param_in_noise_mode
    @cw.noise
    assert @cw.cl.cl_noise.include?('-N 5 '), 'noise N param invalid'
  end

  def test_set_B_param_in_noise_mode
    @cw.noise
    assert @cw.cl.cl_noise.include?('-B 1000 '), 'noise B param invalid'
  end

  def test_set_default_filename
    assert @cw.cl.cl_audio_filename.include?('audio_output.wav'), 'default audio output filename invalid'
  end

  def test_set_audio_filename_to_given_name
    @cw.audio_filename('some name')
    assert @cw.cl.cl_audio_filename.include?("some name"), 'default audio filename invalid'
  end

  def test_set_q_param_when_numeric_quality
    @cw.quality 5
    assert @cw.cl.cl_quality.include?('-q 5 '), 'audio quality invalid'
  end

  def test_set_low_quality
    @cw.quality :low
    assert @cw.cl.cl_quality.include?('-q 9 '), 'audio low quality invalid'
  end

  def test_set_medium_quality
    @cw.quality :medium
    assert @cw.cl.cl_quality.include?('-q 5 '), 'audio medium quality invalid'
  end

  def test_set_high_quality
    @cw.quality :high
    assert @cw.cl.cl_quality.include?('-q 1 '), 'audio high quality invalid'
  end

  def test_build_command_includes_custom_commands_via_build_cl
    @cw.command_line '-x "some custom command"'
    assert @cw.cl.cl_command_line.include?( '-x "some custom command"'), 'custom command invalid'
  end

  def test_cl_echo_returns_correct_string
    str = ''
    CW.new do
      str = @cl.cl_echo('some words')
      pause
    end
    assert str.include?('echo some words | ebook2cw -w 25')
  end

  def test_words_exist
    temp = nil
    CW.new do
      words = 'some words added here'
      temp = words
      pause
    end
    assert_equal(4, temp.split.size)
    CW.new do
      @words.add 'a couple of words'
      temp = words
      pause
    end
    assert_equal(4, temp.split.size)
    CW.new do
      @words.add nil
      temp = words
      pause
    end
    assert_nil(temp)
  end
end
