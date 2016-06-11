require "cw"

# farnsworth_timing_3.rb

CW.new do
  @words.add Array.new(12, 'paris')
  effective_wpm 12
  wpm           15
  word_count    12

  print_letters
end
