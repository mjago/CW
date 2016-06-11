# letter_number_groups_4.rb

require 'cw'

CW.new do
  name " 4 number groups, 6 characters (30 wpm)"
  random_numbers(:size => 5)
  words_including('5')
  word_count 4
  temp = words()
  random_letters(:size => 5)
  words_including('h')
  word_count 4
  self.words += temp
  shuffle
  wpm 30
  print_letters
end
