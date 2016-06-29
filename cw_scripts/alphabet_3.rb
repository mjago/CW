# alphabet_3.rb

require 'cw'

cw do
  alphabet(:include => 'aeiou', :shuffle => true)
  wpm 12
  test_letters
end

