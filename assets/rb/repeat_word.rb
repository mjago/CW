# repeat_word.rb

require 'cw'

CW.new do
  comment "5 common words at 12 wpm (test letters)"
  shuffle
  wpm        12
  word_count 5
  repeat_word
end
