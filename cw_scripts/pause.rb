require "cw"

CW.new do
  word_count 4
  pause
  3.downto 1 do |count|
    sleep 1
    puts count
  end
 un_pause
end
