# five_common_words_3.rb

require 'cw'

cw do
  comment "5 common words at 12 wpm (test letters)"
  shuffle
  wpm        12
  word_count 5
end

cw do
  comment "5 common words at 12 wpm (test words)"
  shuffle
  wpm        12
  word_count 5
  test_words
end
