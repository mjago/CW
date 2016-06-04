# fixed_length_words_3.rb

require 'cw'

CW.new do
  comment "15 most common words having 3 letters (15 WPM)"
  load_most_common_words
  shuffle
  wpm                 15
  word_size            3
  number_of_words     15
end
