require "cw"

# book_reading_4.rb

CW.new do
  book_dir "~/books"
  book_name "book_to_read.txt"
  wpm 18
  ewpm 12
  play_book(sentences: 2)
end

