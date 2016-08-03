require 'simplecov'
$VERBOSE = nil #FIXME
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/cw/config'

class TestConfig < MiniTest::Test

  def setup
    CWG::Params2.reset
  end

  class ConfigurationTest < MiniTest::Test
    def test_configure_block
      CWG::Params2.configure do |cfg|
        cfg.name = "TestName"
        cfg.wpm = 25
        cfg.effective_wpm = 25
      end

      assert_equal "TestName", CWG::Params2.config.name
      assert_equal 25, CWG::Params2.config.wpm

      assert_equal "TestName", CWG::Params2.config[:name]
      assert_equal 25, CWG::Params2.config[:wpm]
    end

    def test_set_not_exists_attribute
      assert_raises NoMethodError do
        CWG::Params2.configure do |config|
          config.unknown_attribute = "TestName"
        end
      end
    end

    def test_get_not_exists_attribute
      assert_raises NoMethodError do
        CWG::Params2.config.unknown_attribute
      end
    end

    def test_default_values
      CWG::Params2.configure { |cfg| cfg.name = [0.1] }
      assert_equal [0.1], CWG::Params2.config.name
    end

    CONFIG_METHODS = [
      :name,:wpm,:effective_wpm,:frequency,:audio_filename,:pause,:audio_dir,
      :book_name,:book_dir,:play_command,:size,:run_default,:word_spacing,
      :command_line,:author,:title,:quality,:ebook2cw_path,:noise,:no_noise,
      :tone,:word_count,:volume,:list_colour,:success_colour,:fail_colour,
      :no_run,:run,:print_letters,:no_print,:use_ebook2cw,:use_ruby_tone,
      :dictionary,:containing,:begin,:end,:including,:word_filename,:max,:min,
      :exit
    ]

    def test_vars
      CWG::Params2.configure do |cfg|
        CONFIG_METHODS.each_with_index do |label,idx|
          cfg[label] = idx + 1
        end
      end
      0.upto CONFIG_METHODS.size - 1 do |idx|
        assert_equal(idx + 1, CWG::Params2.config[CONFIG_METHODS[idx].to_s])
      end
    end

    def test_params_rewrite
      CWG::Cfg.config.params[:test] = 'test'
      assert_equal 'test', CWG::Cfg.config.params[:test]
      CWG::Cfg.config.params[:test] = 'test2'
      assert_equal 'test2', CWG::Cfg.config.params[:test]
    end
  end
end
