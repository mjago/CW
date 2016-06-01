# five-words-five-letters.rb

require 'cw'

CW.new do
  comment "4 words having 6 letters (15 WPM)"
  shuffle
  wpm                 15
  number_of_words     4   # you can use number_of_words or word_count
  word_having_size_of 6   # you can use word_having_size_of or word_length
end
