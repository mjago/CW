$VERBOSE = nil #FIXME

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestPlay < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @p = CWG::Play.new('words')
  end

  def teardown
    @cw = nil
  end

  def test_play_object_takes_a_word_parameter
    play = CWG::Play.new('words object')
    assert_equal 'words object', play.instance_variable_get('@words')
  end

  def test_audio_instantiates_AudioPlayer_object
    assert_equal CWG::AudioPlayer, @p.audio.class
  end

  def test_init_play_words_timeout_sets_start_play_time
    @p.init_play_words_timeout
    assert((Time.now - @p.instance_variable_get('@start_play_time')) < 1)
  end

  def test_init_play_words_timeout_sets_delay_play_time
    @p.init_play_words_timeout
    assert_equal 2.0, @p.instance_variable_get('@delay_play_time')
  end

  def test_start_sync
    refute @p.start_sync?
    @p.start_sync
    assert @p.start_sync?
  end

  def test_add_space
    words = CWG::Words.new
    words.assign ['some','words']

    assert_equal 'some words ',  @p.add_space(words)
  end

end
