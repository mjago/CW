# letter_filtering.rb

require 'cw'

cw do
  name " 4 words beginning with 'j' (18 wpm)"
  shuffle
  beginning_with  'j'
  word_count       4
  wpm             18
end
