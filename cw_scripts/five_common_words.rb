# five-common-words.rb

require 'cw'

cw do
  comment "5 very common words at 12 words per minute"
  shuffle
  word_count 5
  wpm 12
end
