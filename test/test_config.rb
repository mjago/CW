require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw/config'

class TestConfig < MiniTest::Test

  CONFIG_METHODS = [
    :name,:wpm,:effective_wpm,:frequency,:audio_filename,:audio_dir,
    :book_name,:book_dir,:play_command,:size,:run_default,:word_spacing,
    :command_line,:author,:title,:quality,:ebook2cw_path,:noise,:no_noise,
    :tone,:word_count,:volume,:list_colour,:success_colour,:fail_colour,
    :no_run,:run,:print_letters,:no_print,:use_ebook2cw,:use_ruby_tone,
    :dictionary,:containing,:begin,:end,:including,:word_filename,:max,:min,
    :exit
  ]

  def setup
    CW::Cfg.reset
  end

  def test_params_rewrite
    CW::Cfg::CONFIG_METHODS.each_with_index do |label,idx|
      CW::Cfg.config.params[label] = idx
    end
    0.upto CW::Cfg::CONFIG_METHODS.size - 1 do |idx|
      assert_equal(idx, CW::Cfg.config.params[CW::Cfg::CONFIG_METHODS[idx]])
    end
  end

  def test_wpm_default
    assert_equal "25", CW::Cfg.config["wpm"]
  end

  def test_success_colour_default
    assert_equal "green", CW::Cfg.config["success_colour"]
  end

  def test_fail_colour_default
    assert_equal "red", CW::Cfg.config["fail_colour"]
  end

  def test_list_colour_default
    assert_equal "default", CW::Cfg.config["list_colour"]
  end

  def test_ebook2cw_path_default
    assert_equal "/usr/bin/ebook2cw", CW::Cfg.config["ebook2cw_path"]
  end

  def test_run_default_default
    assert_equal "test_letters", CW::Cfg.config["run_default"]
  end

  def test_accessing_unknown_method_returns_nil
    refute CW::Cfg.config["unknown"]
  end

  def test_setting_unknown_method_returns_nil
    CW::Cfg.config.params["unknown"] = "something"
    assert_equal "something", CW::Cfg.config["unknown"]
  end

  def test_an_existing_setting_works
    refute CW::Cfg.config["exit"]
    CW::Cfg.config.params["exit"] = true
    assert CW::Cfg.config["exit"]
  end

  def test_frequency
    CW::Cfg.config.params["frequency"] = 400
    assert_equal 400, CW::Cfg.config["frequency"]
  end
end

