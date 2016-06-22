# range_of_word_lengths_3.rb

require 'cw'

cw do
  comment "2 words having at least 8 letters (15 WPM)"
  shuffle
  wpm                 15
  no_shorter_than     8
  number_of_words     2
end
