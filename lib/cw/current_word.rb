# encoding: utf-8

class CurrentWord

  include TextHelpers

  def initialize
    @current_word = ''
  end

  def current_word
    @current_word ||= String.new
  end

  def push_letter letr
    @current_word += letr
  end

  def to_s
    @current_word
  end

  def clear
    @current_word.clear
    @current_word = ''
  end

  def strip
    @current_word.strip!
  end

  def process_letter letr
    letr.downcase!
    push_letter letr
  end

end
