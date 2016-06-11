require "cw"

# farnsworth_timing_6.rb

CW.new do
  @words.add Array.new(14, 'paris')
  wpm           14
  effective_wpm 12

  print_letters
end
