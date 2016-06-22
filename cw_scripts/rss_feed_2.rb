require "cw"

# rss_feed_2.rb

cw do
  comment 'read 2 BBC news articles'
  read_rss(:bbc, 2)
  wpm 18
  ewpm 12
end

