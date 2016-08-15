require 'parseconfig.rb'

module CWG

  module Cfg

    include CWG::FileDetails

    CONFIG_METHODS = [
      :name,:wpm,:effective_wpm,:frequency,:audio_filename,:audio_dir,
      :book_name,:book_dir,:play_command,:size,:run_default,:word_spacing,
      :command_line,:author,:title,:quality,:ebook2cw_path,:noise,:tone,
      :word_count,:volume,:list_colour,:success_colour,:fail_colour,
      :no_run,:run,:print_letters,:no_print,:use_ebook2cw,
      :dictionary,:containing,:begin,:end,:including,:word_filename,:max,:min,
      :exit, :quit
    ]

    def self.config
      unless @config
        @config = ParseConfig.new(CONFIG_FILENAME)
        CONFIG_METHODS.each do |method|
          unless @config[method.to_s]
            @config.add method.to_s, nil
          end
        end
      end
      @config.params["wpm"] = 50 if(ENV["CW_ENV"] == "test")
      @config.params["effective_wpm"] = 50 if(ENV["CW_ENV"] == "test")
      @config
    end

    def self.reset
      @config = nil
    end

    def self.reset_param param
      @config.params[param] = false
    end

    def self.reset_if_nil param
      self.reset_param param if @config[param].nil?
    end

    def self.get_param param
      self.reset_if_nil param
      @config[param]
    end
  end
end
