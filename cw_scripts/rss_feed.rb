require "cw"

# rss_feed.rb

CW.new do
  comment 'read daily quotation via RSS feed (1 article)'
  read_rss(:quotation, 1)
  wpm 18
  ewpm 12
end

