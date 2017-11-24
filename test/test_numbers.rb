require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw'

class TestNumbers < MiniTest::Test

  ROOT = File.expand_path File.dirname(__FILE__) + '/../'

  def setup
    @dsl = CWG::CwDsl.new
  end

  def teardown
    @dsl = nil
  end

  def test_numbers
    assert_equal ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'], @dsl.numbers
  end


end
