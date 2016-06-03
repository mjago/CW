# fixed_length_words_2.rb

require 'cw'

CW.new do
  comment "4 words having 6 letters (15 WPM)"
  shuffle
  wpm                 15
  word_having_size_of 6   # you can use word_having_size_of or word_length
  number_of_words     4   # you can use number_of_words or word_count
end
