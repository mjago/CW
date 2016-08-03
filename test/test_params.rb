require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/cw'

class TestStr < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @str = CWG::Str.new
  end

  def test_stringify
    assert_equal('a, b', @str.stringify(['a','b']))
  end

#  def test_beginning_str
#    cw = CW.new {
#      no_run
#      assert_equal '', @str.beginning_str
#    }
#  end
end
