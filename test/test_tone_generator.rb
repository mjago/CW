require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestToneGenerator < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    CWG::Cfg.reset
    @tg = CWG::ToneGenerator.new
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

  def test_data_name
    assert_equal :dot, @tg.data[:dot][:name]
    assert_equal :dash, @tg.data[:dash][:name]
    assert_equal :space, @tg.data[:space][:name]
    assert_equal :e_space, @tg.data[:e_space][:name]
  end

  def test_data_filename
    assert_equal File.join(ROOT, '.cw', 'audio', 'dot.wav'), @tg.data[:dot][:filename]
    assert_equal File.join(ROOT, '.cw', 'audio', 'dash.wav'), @tg.data[:dash][:filename]
    assert_equal File.join(ROOT, '.cw', 'audio', 'space.wav'), @tg.data[:space][:filename]
    assert_equal File.join(ROOT, '.cw', 'audio', 'e_space.wav'), @tg.data[:e_space][:filename]
  end

  def test_data_spp_for_15_wpm
    CWG::Cfg.config.params['wpm'] = 15
    tg = CWG::ToneGenerator.new
    element = 192
    assert_equal element * 1, tg.data[:dot][:spb]
    assert_equal element * 3, tg.data[:dash][:spb]
    assert_equal element * 1, tg.data[:space][:spb]
    assert_equal element * 1, tg.data[:e_space][:spb]
  end

  def test_data_spp_for_25_wpm
    CWG::Cfg.config.params['wpm'] = 25
    tg = CWG::ToneGenerator.new
    element = 115
    assert_equal element * 1, tg.data[:dot][:spb]
    assert_equal element * 3, tg.data[:dash][:spb]
    assert_equal element * 1, tg.data[:space][:spb]
    assert_equal element * 1, tg.data[:e_space][:spb]
  end

  def test_data_spp_for_40_wpm
    CWG::Cfg.config.params['wpm'] = 40
    tg = CWG::ToneGenerator.new
    element = 72
    assert_equal element * 1, tg.data[:dot][:spb]
    assert_equal element * 3, tg.data[:dash][:spb]
    assert_equal element * 1, tg.data[:space][:spb]
    assert_equal element * 1, tg.data[:e_space][:spb]
  end

  def test_data_spp_for_20_wpm
    CWG::Cfg.config.params['wpm'] = 20
    tg = CWG::ToneGenerator.new
    element = 144
    assert_equal element * 3, tg.data[:dash][:spb]
    assert_equal element * 1, tg.data[:dot][:spb]
    assert_equal element * 1, tg.data[:space][:spb]
    assert_equal element * 1, tg.data[:e_space][:spb]
  end

  def test_elements
    assert_equal :dot,     @tg.elements.first
    assert_equal :dash,    @tg.elements.fetch(1)
    assert_equal :space,   @tg.elements.fetch(2)
    assert_equal :e_space, @tg.elements.last
    assert_equal 4,        @tg.elements.size
  end

  def test_element_method_generation_dot
    CWG::Cfg.config.params['wpm'] = 20
    tg = CWG::ToneGenerator.new
    element = 144
    assert_equal tg.elements.sort, tg.singleton_methods.sort
    assert_equal :dot, tg.dot[:name]
  end

  def test_generate_samples
    CWG::Cfg.config.params['wpm'] = 40
    tg = CWG::ToneGenerator.new
    samples = tg.generate_samples(:dot)
    assert_equal Array, samples.class
    assert_equal 72, samples.size
    assert_equal samples.size, tg.generate_samples(:space).size
    assert_equal samples.size * 3, tg.generate_samples(:dash).size
    end

  def test_space_or_espace_method_when_no_wpm_equals_ewpm
    assert_equal @tg.space, @tg.space_or_espace
  end

  def test_space_or_espace_method_when_ewpm_active
    @tg.instance_variable_set :@effective_wpm, 10
    assert_equal @tg.e_space, @tg.space_or_espace
  end

  def test_play_filename
    assert_equal File.join(ROOT, 'audio', 'audio_output.wav'), @tg.play_filename
  end

  def test_cw_encoding_returns_a_cw_encoding_object
    assert_equal CWG::CwEncoding, @tg.cw_encoding.class
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
