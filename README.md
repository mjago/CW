# CW

CW is a DSL written in Ruby for generating audible morse, allowing for
real-time learning and testing of Morse Code.

CW can read books, rss feeds, common phrases, QSO codes etc, in
addition to generating random words that match some required pattern
(i.e. words_beginning_with 'v')

CW also allows for real-time marking by indicating correct and
incorrect characters input in real-time.

# Installation:

```sh

gem install cw
ruby example.rb

```

 - Note: Currently only tested on OS X (uses afplay by default).

```ruby

  # example.rb (example script)

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

```

# Options:

  Command / Alias
  ---------------
  -  ewpm                  (effective_wpm)
  -  no_run                (pause)
  -  comment               (name)
  -  repeat_word           (double_words)
  -  word_length           (word_size)
  -  word_shuffle          (shuffle)
  -  having_size_of        (word_size)
  -  number_of_words       (word_count)
  -  words_including       (including)
  -  words_ending_with     (ending_with)
  -  random_alphanumeric   (random_letters_numbers)
  -  words_beginning_with  (beginning_with)
  -  words_no_longer_than  (no_longer_than)
  -  words_no_shorter_than (no_shorter_than)

# License

MIT License
