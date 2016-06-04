# fixed_length_words_3.rb

require 'cw'

CW.new do
  comment "12 common words having 3 letters (15 WPM)"
  shuffle
  wpm                 15
  having_size_of      3
  number_of_words     12
end
