require 'open-uri'

class ReviewCollector
  def initialize(source_links, page_depth = 1, print = true)
    @user_agent = ENV['USER_AGENT_STRING']
    @page_depth = page_depth
    @print = true
    @source_links = source_links
  end

  def reviews
    amazon_reviews(@source_links[:amazon_link]) +
    imdb_reviews(@source_links[:imdb_link]) +
    metacritic_reviews(@source_links[:metacritic_link]) +
    rotten_tomatoes_reviews(@source_links[:rotten_tomatoes_link])
  end

  def amazon_reviews(url)
    return [] unless url
    AmazonScraper.new(url, @user_agent, @page_depth, @print).reviews
  end

  def imdb_reviews(url)
    return [] unless url
    Imdb_Scraper.new(url, @user_agent, @page_depth, @print).reviews
  end

  def metacritic_reviews(url)
    return [] unless url
    MetacriticScraper.new(url, @user_agent, @page_depth, @print).reviews
  end

  def rotten_tomatoes_reviews(url)
    return [] unless url
    Rotten_Tomatoes_Scraper.new(url, @user_agent, @page_depth, @print).reviews
  end
end
