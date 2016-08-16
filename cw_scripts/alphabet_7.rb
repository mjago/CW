# alphabet_7.rb

require 'cw'

cw do
  comment 'test letters a to m'
  wpm 15
  load_alphabet "a".."m"
  shuffle
end

