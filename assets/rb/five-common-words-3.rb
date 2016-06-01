
# ruby five-common-words-3.rb

require 'cw'

CW.new do
  comment "5 common words at 12 wpm (test letters)"
  shuffle
  wpm        12
  word_count 5
  test_letters

  shuffle
  wpm        12
  word_count 5
end
