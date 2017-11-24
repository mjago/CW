$VERBOSE = nil #FIXME

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestTester < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @object = CW::Tester.new

  end

  def teardown
    @object = nil
  end

  def test_whatever
    assert true
  end
#
  def test_quit?
    @object.quit
    assert_equal true, @object.quit?
  end

  def test_quit
    CW::Cfg.config.params["quit"] = false
    refute @object.quit?
    @object.quit
    assert @object.quit?
  end

  def test_print_instantiates_Print_object
    assert_equal CW::Print, @object.print.class
  end

  def test_timing_instantiates_Timing_object
    assert_equal CW::Timing, @object.timing.class
  end
end
