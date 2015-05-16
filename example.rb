require_relative '../cw-0.10.0/lib/cw'

# CW.new do
#   play_book :duration => 0.25
# end
#

wpm = 18
effective_wpm = 15

CW.new do
  wpm       wpm
  effective_wpm   12
  play_book :sentences => 5
end

# CW.new do
#   wpm       16
#   play_book :duration => 0.25
# end

loop do

  #  test = CW.new
  #  test.use_ebook2cw
  #  test.comment         'test ing'
  #  test.shuffle
  #  test.wpm             wpm
  #  test.effective_wpm   effective_wpm
  #  test.beginning_with ['b']
  #  test.word_size       4
  #  test.word_count      10
  #  test.test_words
  #

#   test = CW.new
#   test.comment         'test ing'
#   test.use_ebook2cw
#   #  test.shuffle
#   test.wpm             wpm
#   test.effective_wpm   effective_wpm
#   test.random_numbers
#   #  test.word_size       4
#   #  test.word_count      5
#   #  test.test_words
#   test.test_words


  #  test = CW.new
  #  test.comment         'test ing'
  #  test.use_ebook2cw
  ##  test.shuffle
  #  test.wpm             wpm
  #  test.effective_wpm   effective_wpm
  #  test.beginning_with ['f']
  #  test.word_size       4
  #  test.word_count      5
  #  test.test_words
  #
  #  test = CW.new
  #  test.comment         'test ing'
  #  test.use_ruby_tone
  ##  test.shuffle
  #  test.wpm             wpm
  #  test.effective_wpm   effective_wpm
  #  test.beginning_with ['f']
  #  test.word_size       4
  #  test.word_count      5
  #  test.test_words

  #  test = CW.new
  #  test.comment         'test ing'
  #  test.shuffle
  #  test.wpm             wpm
  #  test.beginning_with ['j']
  #  test.word_size       4
  #  test.word_count      5
  #  test.test_words
  #
  wpm += 1
  break if wpm >=18
end

puts 'done'
