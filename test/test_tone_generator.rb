require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestToneGenerator < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    CW::Cfg.reset
    @tg = CW::ToneGenerator.new
  end

  def teardown
    @tg = nil
  end

  def test_assert
    assert 1
  end

  def test_refute
    refute nil
  end

  def test_code_filename
    assert_equal File.join(ROOT, '.cw', 'audio', 'dot.wav'), @tg.code.filename(:dot)
    assert_equal File.join(ROOT, '.cw', 'audio', 'dash.wav'), @tg.code.filename(:dash)
    assert_equal File.join(ROOT, '.cw', 'audio', 'space.wav'), @tg.code.filename(:space)
    assert_equal File.join(ROOT, '.cw', 'audio', 'e_space.wav'), @tg.code.filename(:e_space)
  end

  def test_code_spb_for_15_wpm
    CW::Cfg.config.params['wpm'] = 15
    tg = CW::ToneGenerator.new
    element = 192
    assert_equal element * 1, tg.code.spb(:dot)
    assert_equal element * 3, tg.code.spb(:dash)
    assert_equal element * 1, tg.code.spb(:space)
    assert_equal element * 1, tg.code.spb(:e_space)
  end

  def test_code_spb_for_25_wpm
    CW::Cfg.config.params['wpm'] = 25
    tg = CW::ToneGenerator.new
    element = 115
    assert_equal element * 1, tg.code.spb(:dot)
    assert_equal element * 3, tg.code.spb(:dash)
    assert_equal element * 1, tg.code.spb(:space)
    assert_equal element * 1, tg.code.spb(:e_space)
  end

  def test_code_spb_for_40_wpm
    CW::Cfg.config.params['wpm'] = 40
    tg = CW::ToneGenerator.new
    element = 72
    assert_equal element * 1, tg.code.spb(:dot)
    assert_equal element * 3, tg.code.spb(:dash)
    assert_equal element * 1, tg.code.spb(:space)
    assert_equal element * 1, tg.code.spb(:e_space)
  end

  def test_code_spb_for_20_wpm
    CW::Cfg.config.params['wpm'] = 20
    tg = CW::ToneGenerator.new
    element = 144
    assert_equal element * 1, tg.code.spb(:dot)
    assert_equal element * 3, tg.code.spb(:dash)
    assert_equal element * 1, tg.code.spb(:space)
    assert_equal element * 1, tg.code.spb(:e_space)
  end

  def test_elements
    assert_equal :dot,     @tg.elements.first
    assert_equal :dash,    @tg.elements.fetch(1)
    assert_equal :space,   @tg.elements.fetch(2)
    assert_equal :e_space, @tg.elements.last
    assert_equal 4,        @tg.elements.size
  end

  def test_generate_samples
    CW::Cfg.config.params['wpm'] = 40
    tg = CW::ToneGenerator.new
    samples = tg.generate_samples(:dot)
    assert_equal Array, samples.class
    assert_equal 72, samples.size
    assert_equal samples.size, tg.generate_samples(:space).size
    assert_equal samples.size * 3, tg.generate_samples(:dash).size
  end

  def test_space_or_espace_method_when_no_wpm_equals_ewpm
    assert_equal({ name: :space }, @tg.space_or_espace)
  end

  def test_space_or_espace_method_when_ewpm_active
    @tg.instance_variable_set :@effective_wpm, 10
    assert_equal({ name: :e_space }, @tg.space_or_espace)
  end

  def test_play_filename
    assert_equal File.join(ROOT, 'audio', 'audio_output.wav'), @tg.play_filename
  end

  def test_cw_encoding_returns_a_cw_encoding_object
    assert_equal CW::Encoding, @tg.cw_encoding.class
  end

  def test_cw_encoding_responds_to_fetch
    assert_equal(true, @tg.cw_encoding.respond_to?(:fetch))
  end

  def test_cw_encoding_fetch_returns_dot_dash_given_the_letter_a
    assert_equal [:dot, :dash], @tg.cw_encoding.fetch('a')
    assert_equal [:dash, :dot], @tg.cw_encoding.fetch('n')
  end

  def test_push_enc_does_something
#    p @tg.push_enc([nil]).class
#    p @tg.push_enc(['a','b'])
    assert_equal 4, @tg.push_enc([nil]).size
    assert_equal 4, @tg.push_enc(['a']).size
    assert_equal 6, @tg.push_enc(['a','b']).size
    assert_equal 8, @tg.push_enc(['a','b','c']).size
    assert_equal 'a', @tg.push_enc(['a','b']).first
    assert_equal Hash, @tg.push_enc(['a','b']).fetch(1).class
    assert_equal 'b', @tg.push_enc(['a','b']).fetch(2)
    assert_equal Hash, @tg.push_enc(['a','b']).last.class
    assert_equal :space, @tg.push_enc(['a','b']).last[:name] = :space
    assert_equal 'b', @tg.push_enc(['a','b']).fetch(2)
    assert_equal Array, @tg.push_enc(['a','b']).class
  end

  def test_word_space_returns_space_if_not_ewpm
#    assert_equal '', @tg.word_space
  end

end
