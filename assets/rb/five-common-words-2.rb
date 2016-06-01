# five-common-words-2.rb

require 'cw'

CW.new do
  comment "5 common words at 12 words per minute"
  shuffle
  wpm        12
  word_count 5
  test_letters
end


