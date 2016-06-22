# letter_number_groups.rb

require 'cw'

cw do
  name " 4 letter groups, of 8 characters (15 wpm)"
  random_letters(:count => 4, :size => 8)
  wpm    15
  test_letters
end
