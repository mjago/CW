require 'parseconfig.rb'

module CWG

  module Params2

    DefaultConfig = Struct.new(
      :name,:wpm,:effective_wpm,:frequency,:audio_filename,:pause,:audio_dir,
      :book_name,:book_dir,:play_command,:size,:run_default,:word_spacing,
      :command_line,:author,:title,:quality,:ebook2cw_path,:noise,:no_noise,
      :tone,:word_count,:volume,:list_colour,:success_colour,:fail_colour,
      :no_run,:run,:print_letters,:no_print,:use_ebook2cw,:use_ruby_tone,
      :dictionary,:containing,:begin,:end,:including,:word_filename,:max,:min,
      :exit
    ) do
      def initialize
        #        self.name = "something"
        #        self.wpm = 10
        #        self.effective_wpm = 10
      end
    end

    def self.reset
      @config = nil
    end

    def self.configure
      @config = DefaultConfig.new
      yield(@config) if block_given?
      @config
    end

    def self.config
      @config || configure
    end
  end

  module Cfg

    HERE = File.dirname(__FILE__) + '/'

    def self.config
      @config ||= ParseConfig.new(File.join HERE, '..', '..', '.cw_config')
    end
  end
end
