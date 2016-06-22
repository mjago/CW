require "cw"
#require "Dir"

cw do
  puts 'quality = 9'
  puts __FILE__
  use_ebook2cw
  quality    9 # worst
  word_count 4
  print_letters
  #  puts File.size('../audio/audio_output.wav0000.mp3')
  dir = File.dirname `gem which cw`
  dir += '/../'
  Dir.entries '/usr/'
end

cw do
  use_ebook2cw
  quality    1 # best
  word_count 4
  print_letters
end
