require "cw"

# book_reading_5.rb

cw do
  wpm 18
  ewpm 12
  comment 'read book (2 sentences, test-by-letter)'
  read_book(sentences: 1, output: :letter)
end
