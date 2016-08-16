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
  wpm 18
  load_alphabet("a".."m")
  shuffle
end

cw do
  comment 'test 8 words made with letters a..m - test by letter'
  wpm 18
  containing('a'..'m')
  shuffle
  word_count 8
end

cw do
  comment 'test letters n..z'
  wpm 18
  load_letters('n'..'z')
  shuffle
end

cw do
  comment 'test 8 words made with letters n..z - test by word'
  wpm 18
  containing('n'..'z')
  shuffle
  word_count 8
  test_words
end

cw do
  comment 'test numbers'
  wpm 20
  load_numbers
  shuffle
end

cw do
  comment 'test alphabet - repeat until correct'
  wpm 25
  load_alphabet
  shuffle
  repeat_word
end

cw do
  comment 'test 8 most common words no longer than 4 letters'
  wpm 20
  load_most_common_words
  shuffle
  no_longer_than 4
  word_count 8
end

cw do
  comment 'test 4 most common words no shorter than 4 letters'
  wpm 20
  load_most_common_words
  shuffle
  no_shorter_than 4
  word_count 8
end

cw do
  comment 'test 8 words including letter sequence "ing"'
  shuffle
  including('ing')
  word_size 6
end

cw do
  comment 'test 8 words having 6 letters - play each word twice'
  shuffle
  word_size 6
  word_count 8
  double_words
end

cw do
  comment 'test 8 words beginning with "qu" - repeat whole sequence once'
  wpm 20
  shuffle
  beginning_with 'qu'
  word_count 8
  repeat 1
end

cw do
  comment 'test 8 words ending with "tion" - test by word'
  wpm 15
  shuffle
  ending_with 'tion'
  word_count 8
  test_words
end

cw do
  comment 'read one sentence of book'
  wpm 20
  read_book(sentences: 1)
end

cw do
  comment 'read rss feed (quote of the day)'
  wpm 18
  read_rss(:quotation, 1)
end

cw do
  comment 'test 6 common cw abbreviations'
  wpm  15
  load_abbreviations
  shuffle
  word_count 6
end

cw do
  comment "test 8 Q codes by ear (no keyboard test)"
  wpm  20
  load_codes
  shuffle
  word_count 8
  print_words
end

cw do
  comment "test 8 words by ear - reveal words at end of test"
  wpm  20
  shuffle
  word_count 8
  reveal
end

cw do
  comment "reverse alphabet"
  wpm 20
  load_alphabet
  reverse
end

cw do
  comment "load my own word set"
  wpm 20
  load_text("test/my_words.txt")
  shuffle
  word_count 4
end

# See documentation for more details - and more commands.

puts 'done'
