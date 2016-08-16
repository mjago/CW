# alphabet_5.rb

require 'cw'

cw do
  comment 'test less than 4 element letters'
  wpm 15
  load_alphabet :less_than, 4
  shuffle
end


