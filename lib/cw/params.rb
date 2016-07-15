# encoding: utf-8

module Params

  extend self

  module ParamsSetup
    CMDS          = [:name,:wpm,:effective_wpm,:frequency,:audio_filename,:pause,
                     :audio_dir, :book_name, :book_dir,:play_command,:size,
                     :run_default, :word_spacing, :command_line, :author,
                     :title, :quality, :ebook2cw_path, :noise, :no_noise,
                     :tone, :word_count]
    PRINT_COLOURS = [:list_colour, :success_colour, :fail_colour]
    BOOL_CMDS     = [[:no_run, :run],[:print_letters, :no_print],
                     [:noise, :no_noise],[:use_ebook2cw, :use_ruby_tone]]
    VARS          = [:dictionary,:containing,:begin,:end,:including,
                     :word_filename,:max,:min,:audio_dir,:book_dir,
                     :book_name,:play_command, :run_default]

    (CMDS + PRINT_COLOURS).each do |method_name|
      define_method method_name do |arg = nil|
        arg ? Params.send("#{method_name}=", arg) : Params.send("#{method_name}")
      end
    end

    BOOL_CMDS.each do |bool|
      define_method bool[0] do
        Params.send("#{bool[0]}=", true)
      end
      define_method bool[1] do
        Params.send("#{bool[0]}=", nil)
      end
    end
  end

  def init_config
    config do
      param(ParamsSetup::CMDS  +
            ParamsSetup::PRINT_COLOURS  +
            ParamsSetup::VARS +
            ParamsSetup::BOOL_CMDS.collect {|cmd| cmd[0]})
    end
  end

  def param_method values, name
    value = values.first
    value ? self.send("#{name}=", value) : instance_variable_get("@#{name}")
  end

  def param_internal name
    attr_accessor name
    instance_variable_set("@#{name}", nil)
    define_method name do | * values|
      param_method values, name
    end
  end

  def param(names)
    names.each do |name|
      param_internal name
    end
  end

  def config( & block)
    instance_eval( & block)
  end

  def word_count_str
    word_count ? "Word count: #{word_count}\n" : nil
  end

  def wpm_str
    "WPM:        #{wpm}\n"
  end

  def word_size_str
    size ? "Word size:  #{size}\n" : nil
  end

  def delim_str
    "#{'=' * Params.name.size}\n"
  end

end
