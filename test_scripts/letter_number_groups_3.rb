# letter_number_groups_3.rb

require 'cw'

CW.new do
  name " 4 groups of mixed letters and numbers with a size of 6 characters (12 wpm)"
  random_letters_numbers(:count => 4, :size => 6)
  wpm 12
  test_letters
end
