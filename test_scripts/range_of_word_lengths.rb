# range_of_word_lengths.rb

require 'cw'

CW.new do
  comment "Eight words, five or less letters (18 WPM)"
  shuffle
  no_longer_than 5
  word_count     8
  wpm            18
end
