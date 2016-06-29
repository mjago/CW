# alphabet_5.rb

require 'cw'

cw do
  alphabet(:exclude => 'abcdefghijklm')
  wpm 12
  test_letters
end

