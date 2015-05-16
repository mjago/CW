#class Rss

class Rss

  def rss_source source
    {
      bbc_europe: 'http://feeds.bbci.co.uk/news/rss.xml',
      reuters:    'http://feeds.reuters.com/Reuters/worldNews?format=xml',
      guardian:   'http://www.theguardian.com/world/rss',
      quotations: 'http://feeds.feedburner.com/quotationspage/qotd',
      default:    'http://feedjira.com/blog/feed.xml'
    }[source] ? self[:source] : self[:default]
  end

  def read_rss(source, show_count = 3)
    require 'feedjira'
    require "htmlentities"
    require 'sanitize'
    coder = HTMLEntities.new
    url   = rss_addr source
    feed  = Feedjira::Feed.fetch_and_parse url # returns a Hash, with each url having a Feedjira::Feed object
    entry_count = 0
    @rss_articles = []
    entry = feed.entries.each do |entry|
      title = entry.title
      unless(title.include?('VIDEO:') ||
             title.include?('In pictures:') ||
             title.include?('Morning business round-up'))
        words = entry.summary
        entry_count += 1
      end
      @rss_articles << (Sanitize.clean coder.decode words).gsub(".", "= ").split(',')
      #      @words = words.split(' ')
      break if entry_count >= show_count
    end
    @rss_flag = true
  end
end
