$VERBOSE = nil #FIXME

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestTester < MiniTest::Test

#  include Tester

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @object = Object.new
    @object.extend(Tester)
#''end    @cw = CW.new
#    @cw.pause
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

  def test_global_quit?
    @object.instance_eval('@global_quit = :quit')
    assert_equal :quit, @object.global_quit?
  end

  def test_global_quit
    assert_nil @object.global_quit?
    @object.global_quit
    assert @object.global_quit?
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
