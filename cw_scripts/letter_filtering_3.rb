# letter_filtering_3.rb

require 'cw'

cw do
  comment "4 words ending with 'ing' (15 WPM)"
  shuffle
  wpm                 18
  ending_with         'ing'
  number_of_words     4
  test_letters
end
