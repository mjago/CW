# encoding: utf-8

require_relative 'cw/file_details'
require_relative 'cw/config'
require_relative 'cw/os'
require_relative 'cw/process'
require_relative 'cw/text_helpers'
require_relative 'cw/tone_helpers'
require_relative 'cw/element'
require_relative 'cw/current_word'
require_relative 'cw/cw_encoding'
require_relative 'cw/cw_dsl'
require_relative 'cw/randomize'
require_relative 'cw/sentence'
require_relative 'cw/alphabet'
require_relative 'cw/numbers'
require_relative 'cw/str'
require_relative 'cw/rss'
require_relative 'cw/words'
require_relative 'cw/cl'
require_relative 'cw/key_input'
require_relative 'cw/cw_stream'
require_relative 'cw/timing'
require_relative 'cw/print'
require_relative 'cw/audio_player'
require_relative 'cw/cw_threads'
require_relative 'cw/book_details'
require_relative 'cw/tester'
require_relative 'cw/play'
require_relative 'cw/test_words'
require_relative 'cw/test_letters'
require_relative 'cw/repeat_word'
require_relative 'cw/reveal'
require_relative 'cw/book'
#require_relative 'cw/tx'
require_relative 'cw/tone_generator'
require_relative 'cw/progress'
require_relative 'cw/common_words'
require_relative 'cw/callsign'

def cw &block
  CW.new do
    instance_eval(&block)
  end
end

# CW provides Morse code generation functionality
# Inherits CwDsl

class CW < CWG::CwDsl

  # Initialize CW class. Eval block if passed in.

  def initialize(&block)
    super
    instance_eval(&block) if block
    run if block
  end
end
