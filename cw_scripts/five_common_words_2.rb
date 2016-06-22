# five_common_words_2.rb

require 'cw'

cw do
  comment "5 common words at 12 words per minute"
  shuffle
  wpm        12
  word_count 5
  test_letters    # add the command test_letters here
end
