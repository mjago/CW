require "cw"

# book_reading_5.rb

CW.new do
  wpm 18
  ewpm 12
  comment 'read book (2 sentences, test-by-letter)'
  play_book(sentences: 1, output: :letter)
end
