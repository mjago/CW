# alphabet_10.rb

require 'cw'

cw do
  comment 'test single element letters'
  wpm 15
  load_alphabet :size, 1
  shuffle
end

cw do
  comment 'test 2 element letters'
  wpm 15
  load_alphabet :size, 2
  shuffle
end

cw do
  comment 'test less than 3 element letters'
  wpm 15
  load_alphabet :less_than, 3
  shuffle
end

cw do
  comment 'test 3 element letters'
  wpm 15
  load_alphabet :size, 3
  shuffle
end

cw do
  comment 'test less than 4 element letters'
  wpm 15
  load_alphabet :less_than, 4
  shuffle
end

cw do
  comment 'test 4 element letters'
  wpm 15
  load_alphabet :size, 4
  shuffle
end

cw do
  comment 'test alphabet vowels'
  wpm 15
  load_vowels
  shuffle
end

cw do
  comment 'test letters a..m'
  wpm 15
  load_alphabet("a".."m")
  shuffle
end

cw do
  comment 'test 4 small words made with letters a..m'
  wpm 15
  containing('a'..'m')
  shuffle
  word_size 2
  word_count 4
end

cw do
  comment 'test letters n..z'
  wpm 15
  load_letters('n'..'z')
  shuffle
end

cw do
  comment 'test 4 small words made with letters n..z'
  wpm 15
  containing('n'..'z')
  shuffle
  word_size 2
  word_count 4
end

cw do
  comment 'test entire alphabet'
  wpm 15
  load_alphabet
  shuffle
end

