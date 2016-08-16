# alphabet_3.rb

require 'cw'

cw do
  comment 'test less than 3 element letters'
  wpm 15
  load_alphabet :less_than, 3
  shuffle
end


