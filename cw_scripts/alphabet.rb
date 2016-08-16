# alphabet.rb

require 'cw'

cw do
  comment 'test single element letters'
  wpm 15
  load_alphabet :size, 1
  shuffle
  print_letters
end
