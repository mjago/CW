# alphabet_8.rb

require 'cw'

cw do
  comment 'test letters n to z'
  wpm 15
  load_alphabet "n".."z"
  shuffle
end

