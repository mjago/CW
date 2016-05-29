[![Gem Version](https://badge.fury.io/rb/cw.svg)](https://badge.fury.io/rb/cw)
[![Build Status](https://travis-ci.org/mjago/CW.svg?branch=master)](https://travis-ci.org/mjago/CW)
[![Code Climate](https://codeclimate.com/github/mjago/CW/badges/gpa.svg)](https://codeclimate.com/github/mjago/CW)
[![Dependency Status](https://gemnasium.com/badges/github.com/mjago/CW.svg)](https://gemnasium.com/github.com/mjago/CW)

## CW

CW is a DSL written in the [Ruby](https://www.ruby-lang.org/en/downloads/) language for generating audible morse - allowing for
real-time learning and testing of Morse Code. Great emphasis is placed on enabling tests to use fresh material each test run, rather than the constant repetition of old material.

CW can read books (and remember where you are), rss feeds (your daily quotation for instance), common phrases, QSO codes etc, in
addition to generating random words, letters, and numbers that possibly match some required pattern
(i.e. words_beginning_with 'v').

CW also allows for real-time progress marking by indicating correct and incorrect characters and words copied in real-time. A follow mode also exists which prints the output just after it has played it (for `in head' practice).

Documentation to follow...

# Installation:

```sh

gem install cw
ruby example.rb

```
# Run tests

```sh

gem install --dev cw
ruby test/test_cw.rb

```

 * Note: Currently only tested on OS X, and Ruby v2.0.0 and greater.

```ruby

  # example.rb (example script)

  require 'cw'

  CW.new do
    wpm 18
    comment 'read book (1 sentence)'
    play_book(sentences: 1)
  end

  CW.new do
    wpm 18
    ewpm 12
    comment 'read book (2 minutes)'
    play_book(duration: 2)
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

# Options:

  Command / Alias
  ---------------
 -  ewpm                  / effective_wpm
 -  no_run                / pause
 -  comment               / name
 -  repeat_word           / double_words
 -  word_length           / word_size
 -  word_shuffle          / shuffle
 -  random_letters
 -  random_numbers
 -  having_size_of        / word_size
 -  number_of_words       / word_count
 -  words_including       / including
 -  words_ending_with     / ending_with
 -  random_alphanumeric   / random_letters_numbers
 -  words_beginning_with  / beginning_with
 -  words_no_longer_than  / no_longer_than
 -  words_no_shorter_than / no_shorter_than

# License

MIT License
