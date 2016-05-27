require 'cw'

CW.new do
  comment 'read book feed (1 sentence)'
  play_book(sentences: 1)
end

CW.new do
  comment 'read book feed (1 minute)'
  play_book(duration: 1)
end

CW.new do
  comment 'read rss feed (1 article)'
  read_rss(:reuters, 1)
end

CW.new do
  name 'test straight alphabet'
  alphabet
end

CW.new do
  comment 'test straight numbers'
  numbers
end

CW.new do
  wpm  18
  ewpm 12
  load_abbreviations
  shuffle
end

CW.new do
  wpm  18
  ewpm 12
  load_q_codes
  shuffle
end

def cw_settings
  shuffle
  wpm 20
  ewpm 15
  #  use_ebook2cw
  use_ruby_tone
  mark_words
  word_count 5
  word_size 4
  print_letters
  puts self.to_s
end

CW.new do
  comment 'test random letters'
  random_letters(size: 4)
  cw_settings
end

CW.new do
  comment 'test random numbers'
#  use_ebook2cw
  cw_settings
  random_numbers(count: 2, size: 5)
end

CW.new do
  comment 'test random letters numbers'
#  use_ebook2cw
  cw_settings
  random_letters_numbers(count: 2, size: 11)
end

wpm = 15
ewpm = 12
loop do

  test = CW.new
#  test.use_ebook2cw
  test.comment 'test words beginning with b'
  test.shuffle
  test.wpm             wpm
  test.effective_wpm   ewpm
  test.beginning_with  'b'
  test.word_size       4
  test.word_count      4
  puts test.to_s
  test.test_words

  test = CW.new
  test.comment 'test words including ing'
#  test.use_ebook2cw
  test.shuffle
  test.wpm             wpm
  test.effective_wpm   ewpm
  test.including       'ing'
  test.word_count      5
  test.test_words

  #  test = CW.new
  #  test.comment         'test ing'
  #  test.use_ebook2cw
  ##  test.shuffle
  #  test.wpm             wpm
  #  test.effective_wpm   ewpm
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
  #  test.effective_wpm   ewpm
  #  test.beginning_with ['f']
  #  test.word_size       4
  #  test.word_count      5
  #  test.test_words

  #  test = CW.new
  #  test.comment         'test ing'
  #  test.shuffle
  #  test.wpm             wpm
  #  test.effective_wpm   ewpm
  #  test.beginning_with ['j']
  #  test.word_size       4
  #  test.word_count      5
  #  test.test_words
  #
  wpm += 2
  break if wpm >= 24
end

puts 'done'
