$VERBOSE = nil #FIXME

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestTester < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @object = Tester.new

  end

  def teardown
    @cw = nil
  end

  def test_whatever
    assert true
  end
#
  def test_quit?
    @object.instance_eval('@quit = :quit')
    assert_equal :quit, @object.quit?
  end

  def test_quit
    assert_nil @object.quit?
    @object.quit
    assert @object.quit?
  end

  def test_print_instantiates_Print_object
    assert_equal Print, @object.print.class
  end

  def test_timing_instantiates_Timing_object
    assert_equal Timing, @object.timing.class
  end

  def test_audio_instantiates_AudioPlayer_object
    assert_equal AudioPlayer, @object.audio.class
  end

end
