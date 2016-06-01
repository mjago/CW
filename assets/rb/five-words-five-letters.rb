# five-words-five-letters.rb

require 'cw'

CW.new do
  comment "5 words having 5 letters (12 WPM)"
  shuffle
  word_count 5
  word_length 4
  wpm 12
  test_letters
end
