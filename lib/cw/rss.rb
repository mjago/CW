# encoding: utf-8

#class Rss

class Rss

  def sources
    {
      bbc:        'http://feeds.bbci.co.uk/news/rss.xml',
      reuters:    'http://feeds.reuters.com/Reuters/worldNews?format=xml',
      guardian:   'http://www.theguardian.com/world/rss',
      quotation: 'http://feeds.feedburner.com/quotationspage/qotd'
    }
  end

  def source src
    sources.has_key?(src) ? sources[src] : sources[:quotation]
  end

  def read_rss(src, article_count = 3)
    require 'feedjira'
    require "htmlentities"
    require 'sanitize'
    coder = HTMLEntities.new
    url   = source(src)
    # return a Hash - each url having a Feedjira::Feed object
    feed  = Feedjira::Feed.fetch_and_parse url
    entry_count = 0
    @rss_articles = []
    feed.entries.each do |entry|
      title = entry.title
      unless(title.include?('VIDEO:') ||
             title.include?('In pictures:') ||
             title.include?('Morning business round-up'))
        words = entry.summary
        entry_count += 1
      end
      @rss_articles << (Sanitize.clean coder.decode words).split(',')
      break if entry_count >= article_count
    end
    @rss_flag = true
  end

  def inc_article_index
    @article_index += 1
  end

  def article_index
    @article_index || @article_index = 0
  end

  def cw_chars chr
    chr.tr('^a-z0-9\.\,+', '')
  end

  def exclude_non_cw_chars word
    temp = ''
    word.split.each do |chr|
      temp += chr if letter(chr)
    end
    temp
  end

  def next_article
    temp = @rss_articles[article_index]
    return unless temp
    inc_article_index
    quote = ''
    temp.map { |i| quote += i }
    (quote.split.collect { |article| cw_chars(article.strip.gsub("\"", '').downcase)})
  end
end
