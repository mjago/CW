# fixed_length_words_2.rb

require 'cw'

cw do
  comment "4 words having 6 letters (15 WPM)"
  shuffle
  wpm                 15
  word_length         6
  number_of_words     4 # you can use number_of_words!
end
