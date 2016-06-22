[![Gem Version](https://badge.fury.io/rb/cw.svg)](https://badge.fury.io/rb/cw)
[![Build Status](https://travis-ci.org/mjago/CW.svg?branch=master)](https://travis-ci.org/mjago/CW)
[![Code Climate](https://codeclimate.com/github/mjago/CW/badges/gpa.svg)](https://codeclimate.com/github/mjago/CW)
[![Dependency Status](https://gemnasium.com/badges/github.com/mjago/CW.svg)](https://gemnasium.com/github.com/mjago/CW)

## CW

**CW** is a program for learning and practicing Morse Code (CW). It is written in the form of a [DSL](https://en.wikipedia.org/wiki/Domain-specific_language/) in the [Ruby](https://www.ruby-lang.org/en/downloads/) language.

**CW** can read _books_ (and remember where you are), _rss feeds_ (your daily quotation for instance), common _phrases_, _QSO_ codes etc, in
addition to generating random words, letters, and numbers that possibly match some required pattern (i.e. words_beginning_with 'v').

**CW** also allows for real-time progress marking by indicating correct and incorrect characters and words copied in real-time. A follow mode also exists which prints the output just after it has played it (for `in head' practice).

**CW** is thoroughly [documented](http://mjago.github.io/CW/), and includes a [hands-on tutorial](http://mjago.github.io/CW/mydoc_five_common_words/).

# Installation:

```sh
gem install cw
ruby example.rb
```

 * Note: Currently only tested on OS X, and Ruby v1.9.3 and later.

# Documentation:

**[CW Documentation](http://mjago.github.io/CW/)**

# Example test-script

```ruby

# example.rb (example script)

  require 'cw'

  cw do
    wpm 18
    comment 'read book (1 sentence)'
    play_book(sentences: 1)
  end

  cw do
    wpm 18
    ewpm 12
    comment 'read book (2 minutes)'
    play_book(duration: 2)
  end

  cw do
    comment 'read rss feed (1 article)'
    read_rss(:reuters, 1)
  end

  cw do
    name 'test straight alphabet'
    alphabet
  end

  cw do
    comment 'test straight numbers'
    numbers
  end

  cw do
    wpm  18
    ewpm 12
    load_abbreviations
    shuffle
  end


# ...or instantiate CW...

wpm = 16

test = CW.new
test.comment 'test words beginning with "b" (repeat word)'
test.shuffle
test.wpm             wpm
test.beginning_with  'b'
test.word_size        4
test.word_count       2
puts test.to_s
test.repeat_word

test = CW.new
test.comment 'test words ending with "ing" (test letters)'
test.shuffle
test.wpm             wpm
test.ending_with     'e'
test.word_size        4
test.word_count       2
puts test.to_s
test.test_letters

test = CW.new
test.comment 'test words including "th" (test words)'
test.shuffle
test.wpm             wpm
test.including       'th'
test.word_size        4
test.word_count       2
puts test.to_s
test.test_words

test = CW.new
test.comment 'test words no longer than 6 letters (test letters)'
test.shuffle
test.wpm             wpm
test.no_longer_than   6
test.word_count       2
puts test.to_s
test.test_letters

test = CW.new
test.comment 'test words no shorter than 6 letters (print letters)'
test.shuffle
test.wpm             wpm
test.no_shorter_than  6
test.word_count       2
puts test.to_s
test.print_letters
test.test_letters

```

# License

[MIT License](https://raw.githubusercontent.com/mjago/CW/master/LICENSE)
