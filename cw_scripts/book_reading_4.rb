require "cw"

# book_reading_4.rb

cw do
  book_dir "data/text/"
  book_name "book.txt"
  wpm 18
  ewpm 12
  read_book(sentences: 2)
end

