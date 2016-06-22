require "cw"

# farnsworth_timing_3.rb

cw do
  @words.add Array.new(12, 'paris')
  effective_wpm 12
  wpm           18
  word_count    12

  print_letters
end
