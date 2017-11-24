# encoding: utf-8

require 'oga'
require 'httpclient'
require "htmlentities"

module CW

  #class Rss

  class Rss

    include TextHelpers

    def sources
      {
        bbc:       'http://feeds.bbci.co.uk/news/rss.xml',
        reuters:   'http://feeds.reuters.com/Reuters/worldNews?format=xml',
        guardian:  'http://www.theguardian.com/world/rss',
        quotation: 'http://feeds.feedburner.com/quotationspage/qotd'
      }
    end

    def source src
      sources.has_key?(src) ? sources[src] : sources[:quotation]
    end

    def read_rss(src, article_count = 3)

      Cfg.config.params["words_counted"] = true
      @rss_articles = []
      count = 0
      coder = HTMLEntities.new
      url   = source(src)
      content = HTTPClient.new.get_content(url)
      document = Oga.parse_xml(content)
      document.xpath('rss/channel/item').each do |item|
        title = item.at_xpath('title').text
        description = item.at_xpath('description').text
        unless(title.include?('VIDEO:') ||
               title.include?('In pictures:') ||
               title.include?('Morning business round-up'))
          clean_title = CW::RSSClean.new(title).scrub
          clean_desc = CW::RSSClean.new(description).scrub
#          @rss_articles << Sanitize.clean(coder.decode(title)) + '. ' +
          #                           Sanitize.clean(coder.decode(description))
          @rss_articles << clean_title + '. ' + clean_desc
          count += 1
          break if count >= article_count
        end
      end
    end

    def inc_article_index
      @article_index += 1
    end

    def article_index
      @article_index || @article_index = 0
    end

    def next_article
      article = @rss_articles[article_index]
      return unless article
      inc_article_index
      article.split.collect do |chars|
        cw_chars(chars.strip.delete("\"").downcase)
      end
    end
  end
end
