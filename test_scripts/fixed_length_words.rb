# fixed_length_words.rb

require 'cw'

CW.new do
  comment "5 words having 4 letters (12 WPM)"
  shuffle
  wpm           12
  word_length   5
  word_count    4
  test_letters
end
