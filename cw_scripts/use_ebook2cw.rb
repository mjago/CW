require "cw"

cw = CW.new
cw.use_ebook2cw
cw.word_count 4
cw.test_words

cw.use_ruby_tone
cw.test_words
