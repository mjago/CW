# callsign_2.rb

require 'cw'

puts "cq de callsign k 5 times"
5.times do
  cw do
    comment 'random frequency, random wpm callsign with pre and postamble'
    frequency 500 + rand(400)
    wpm 25 + rand(10)
    callsign
    (words.unshift "cq de") << 'k'
    print_letters
  end
end
