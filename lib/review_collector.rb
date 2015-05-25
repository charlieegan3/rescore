require 'open-uri'

class ReviewCollector
  def initialize(page_depth = 1, print = true)
    @user_agent = ENV['USER_AGENT_STRING']
    @page_depth = page_depth
    @print = true
  end

  def metacritic_reviews(url)
    MetacriticScraper.new(url, @user_agent, @page_depth, @print).reviews
  end

  def amazon_reviews(url)
    AmazonScraper.new(url, @user_agent, @page_depth, @print).reviews
  end

  def imdb_reviews(url)
    Imdb_Scraper.new(url, @user_agent, @page_depth, @print).reviews
  end

  def rotten_tomatoes_reviews(url)
    Rotten_Tomatoes_Scraper.new(url, @user_agent, @page_depth, @print).reviews
  end
end
