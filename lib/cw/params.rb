# encoding: utf-8

module Params

  extend self

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

  def shuffle_str
    shuffle ? "Shuffle:    #{shuffle ? 'yes' : 'no'}\n" : nil
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
