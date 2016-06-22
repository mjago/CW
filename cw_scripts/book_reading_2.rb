require "cw"

# book_reading_2.rb

cw do
  comment 'read book for one minute (18 wpm, 12 ewpm)'
  wpm 18
  ewpm 12
  play_book(duration: 1)
  print_words
end

