require "cw"

# book_reading_4.rb

cw do
  book_dir "~/books"
  book_name "book_to_read.txt"
  wpm 18
  ewpm 12
  read_book(sentences: 2)
end

