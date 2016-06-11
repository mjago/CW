require "cw"

# book_reading.rb

CW.new do
  comment 'read two sentences of book (18 wpm, 12 ewpm)'
  wpm 18
  ewpm 12
  play_book(sentences: 2)
end
