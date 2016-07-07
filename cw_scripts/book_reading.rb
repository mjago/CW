require "cw"

# book_reading.rb

cw do
  comment 'read two sentences of book (18 wpm, 12 ewpm)'
  wpm 18
  ewpm 12
  read_book(sentences: 2)
end
