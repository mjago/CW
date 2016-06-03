# letter_number_groups_2.rb

require 'cw'

CW.new do
  name " 4 number groups, 6 characters (15 wpm)"
  random_numbers(:count => 4, :size => 6)
  wpm 15
  test_letters
end
