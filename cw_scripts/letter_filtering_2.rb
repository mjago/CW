# letter_filtering_2.rb

require 'cw'

CW.new do
  name " 4 words beginning with 'qu' (18 wpm)"
  shuffle
  beginning_with  'qu'
  word_count       4
  wpm             18
  test_letters
end
