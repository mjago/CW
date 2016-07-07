# encoding: utf-8

now = Time.now

require_relative 'lib/cw'

speed = 15

CW.new do
  shuffle
  wpm speed
  ewpm speed - 2
  word_count 5
  test_letters
end

CW.new do
  shuffle
  wpm speed
  word_count 15
  test_letters
end

speed += 5

CW.new do
  wpm speed
  load_abbreviations
  shuffle
  repeat_word
end

CW.new do
  wpm speed
  load_abbreviations
  shuffle
  repeat_word
end

CW.new do
  wpm speed
  load_most_common_words
  word_count 40
  shuffle
  repeat_word
end


CW.new do
  wpm speed
  load_most_common_words
  word_count 40
  shuffle
  double_words
  test_letters
end


speed -= 5

CW.new do
  wpm  speed
  read_book output: :letter, duration: 2
end

CW.new do
  wpm speed
  read_rss(:reuters, 2)
end

speed += 15

CW.new do
  wpm speed
  load_alphabet
  shuffle
  repeat_word
end

CW.new do
  2.times do
    wpm speed
    load_numbers
    shuffle
    repeat_word
  end
end

speed -= 10

CW.new do
  load_words 'data/text/cw_conversation.txt'
  wpm speed
  print_letters
end

seconds = (Time.now - now).to_i

if seconds == 0
  puts 'No tests run!'
else
  minutes = 0
  if seconds >= 60
    minutes = (seconds / 60).to_i
    seconds = seconds % 60
  end
  print "Daily run completed in "
  print "#{minutes} minute" if minutes > 0
  print 's' if minutes > 1
  print ', ' if((seconds > 0) && (minutes > 0))
  print "#{seconds} second" if seconds > 0
  print 's' if seconds > 1
  puts '.'
end

#if seconds >
#puts "Daily run completed in #{().to_i} seconds"
#
#CW.new do
#  shuffle
#  use_ebook2cw
##  ewpm 18
#  wpm  30
#  words_no_longer_than  3
#  word_count 25
##  words = "ABC"
##  test_words
##  test_letters
##  read_book
#  repeat_word
#  #print_letters
#end

#CW.new do
##  shuffle
#  wpm  15
#  word_count 5
##  test_letters
#  #print_letters
#end

# CW.new do
#   shuffle
#   wpm  18
#   ewpm 15
#   word_count 15
#   #print_letters
# end
#
# CW.new do
#   shuffle
#   wpm  18
#   ewpm 15
#   word_count 15
#   #print_letters
# end
#
# CW.new do
#   shuffle
#   wpm  18
#   ewpm 15
#   word_count 15
#   #print_letters
# end
#
# CW.new do
#   shuffle
#   wpm  18
#   ewpm 15
#   word_count 15
#   #print_letters
# end
#
# CW.new do
#   shuffle
#   wpm  18
#   ewpm 15
#   word_count 15
#   #print_letters
# end
#
#
