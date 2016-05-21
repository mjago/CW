# encoding: utf-8

now = Time.now

require_relative 'lib/cw'

speed = 20

CW.new do
  wpm  speed
  play_book output: :letter, duration: 10
end


seconds = (Time.now - now).to_i

if seconds == 0
  puts 'No tests run!'
else
  minutes = 0
  if seconds >= 60
    minutes = (seconds / 60).to_i
    seconds = seconds % 60
  end
  print "Daily run completed in "
  print "#{minutes} minute" if minutes > 0
  print 's' if minutes > 1
  print ', ' if((seconds > 0) && (minutes > 0))
  print "#{seconds} second" if seconds > 0
  print 's' if seconds > 1
  puts '.'
end

