# encoding: utf-8

module Params

  module ParamsSetup

    [:name,          :wpm,
     :effective_wpm, :word_spacing,
     :command_line,  :frequency,
     :author,        :title,
     :quality,       :audio_filename,
     :pause,         :noise,
     :audio_dir,     :book_name,
     :book_dir,      :play_command,
     :success_colour,:fail_colour,
     :list_colour,   :ebook2cw_path,
     :run_default,   :no_run
    ].each do |method_name|
      define_method method_name do |arg = nil|
        arg ? Params.send("#{method_name}=", arg) : Params.send("#{method_name}")
      end
    end

    [[:run, :no_run, nil],
     [:no_run, :no_run, true],
     [:print_letters, :print_letters, true],
     [:no_print, :print_letters, nil],
     [:noise, :noise, true],
     [:no_noise, :noise, nil],
     [:use_ebook2cw, :use_ebook2cw, true],
     [:use_ruby_tone, :use_ebook2cw, nil],
    ].each do |bool|
      define_method bool[0] do
        Params.send("#{bool[1]}=", bool[2])
      end
    end

  end

  extend self

  def init_config
    config do
      param :name, :wpm, :dictionary, :command_line, :audio_filename, :tone, :pause,
            :print_letters, :word_filename, :author, :title, :quality,
            :frequency, :effective_wpm, :max, :min, :word_spacing, :noise,
            :begin, :end, :word_count, :including, :word_size, :size, :beginning_with,
            :ending_with, :audio_dir, :use_ebook2cw, :book_dir, :book_name,
            :play_command, :success_colour, :fail_colour, :list_colour,
            :ebook2cw_path, :run_default, :no_run
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

  def param( * names)
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
