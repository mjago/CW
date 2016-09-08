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
    CWG::Cfg.reset
  end

  def test_params_rewrite
    CWG::Cfg::CONFIG_METHODS.each_with_index do |label,idx|
      CWG::Cfg.config.params[label] = idx
    end
    0.upto CWG::Cfg::CONFIG_METHODS.size - 1 do |idx|
      assert_equal(idx, CWG::Cfg.config.params[CWG::Cfg::CONFIG_METHODS[idx]])
    end
  end

  def test_wpm_default
    assert_equal "25", CWG::Cfg.config["wpm"]
  end

  def test_book_name_default
    assert_equal "book.txt", CWG::Cfg.config["book_name"]
  end

  def test_book_dir_default
    assert_equal "data/text/", CWG::Cfg.config["book_dir"]
  end

#  def test_play_command_default
#    assert_equal "/usr/bin/afplay", CWG::Cfg.config["play_command"]
#  end

  def test_success_colour_default
    assert_equal "green", CWG::Cfg.config["success_colour"]
  end

  def test_fail_colour_default
    assert_equal "red", CWG::Cfg.config["fail_colour"]
  end

  def test_list_colour_default
    assert_equal "default", CWG::Cfg.config["list_colour"]
  end

  def test_ebook2cw_path_default
    assert_equal "/usr/bin/ebook2cw", CWG::Cfg.config["ebook2cw_path"]
  end

  def test_run_default_default
    assert_equal "test_letters", CWG::Cfg.config["run_default"]
  end

  def test_accessing_unknown_method_returns_nil
    refute CWG::Cfg.config["unknown"]
  end

  def test_setting_unknown_method_returns_nil
    CWG::Cfg.config.params["unknown"] = "something"
    assert_equal "something", CWG::Cfg.config["unknown"]
  end

  def test_an_existing_setting_works
    refute CWG::Cfg.config["exit"]
    CWG::Cfg.config.params["exit"] = true
    assert CWG::Cfg.config["exit"]
  end

  def test_frequency
    CWG::Cfg.config.params["frequency"] = 400
    assert_equal 400, CWG::Cfg.config["frequency"]
  end
end

