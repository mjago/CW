require "cw"

# farnsworth_timing_6.rb

CW.new do
  @words.add Array.new(13, 'paris')
  wpm           13
  effective_wpm 12

  print_letters
end
