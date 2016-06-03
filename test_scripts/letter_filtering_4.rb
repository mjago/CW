# letter_filtering_4.rb

require 'cw'

CW.new do
  comment "4 words containing 'ain' (15 WPM)"
  shuffle
  wpm                 18
  words_including    'ain'
  number_of_words     4
  test_letters
end
