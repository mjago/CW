# encoding: utf-8

require 'thread'

class MonitorKeys
  def initialize(cw)
    @cw = cw
    @key_input = KeyInput.new
    @queue     = Queue.new
  end

  def key_input
    @key_input ||= KeyInput.new
  end

  def empty?
    @queue.empty?
  end

  def have_data?
    ! empty?
  end

  def monitor_keys
    loop do
      get_key_input
      break if check_quit_key_input?
      if @cw.quit
        key_input.reset
        break
      end
      check_sentence_navigation key_chr
      build_word_maybe
    end
  end

end
