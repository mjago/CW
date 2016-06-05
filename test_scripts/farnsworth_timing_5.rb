require "cw"

# farnsworth_timing_5.rb

CW.new do
  @words.add Array.new(12, 'paris')
  effective_wpm 12
  wpm           12


  print_letters
end
