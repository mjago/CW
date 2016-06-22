# range_of_word_lengths_2.rb

require 'cw'

cw do
  comment "8 words having size between 2 and 4 letters (15 WPM)"
  shuffle
  wpm                 15
  no_shorter_than     2
  no_longer_than      4
  number_of_words     8
end
