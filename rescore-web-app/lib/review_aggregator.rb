require_relative 'scrapers/amazon_scraper'
require_relative 'scrapers/rt_scraper'
require_relative 'scrapers/metacritic_scraper'
require_relative 'scrapers/imdb_scraper'

require 'googleajax'
require 'open-uri'

require 'pry'

class ReviewAggregator
  def initialize(film_title, page_depth = 1, print = true)
    @film_title = film_title
    @user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2'
    @page_depth = page_depth
    @print = true
  end

  def reviews(include_diagnostics = true)
    diagnostics = {}
    start_time = Time.new

    sources = source_urls
    diagnostics[:source_collection_time] = Time.new - start_time; start_time = Time.new
    diagnostics[:sources] = sources

    reviews = []
    reviews += MetacriticScraper.new(sources[:metacritic_title_url], @user_agent, @page_depth, @print).reviews
    diagnostics[:metacritic_time] = Time.new - start_time; start_time = Time.new
    reviews += AmazonScraper.new(sources[:amazon_title_url], @user_agent, @page_depth, @print).reviews
    diagnostics[:amazon_time] = Time.new - start_time; start_time = Time.new
    reviews += IMDbScraper.new(sources[:imdb_title_url], @user_agent, @page_depth, @print).reviews
    diagnostics[:imdb_time] = Time.new - start_time; start_time = Time.new
    reviews += RtScraper.new(sources[:rotten_title_url], @user_agent, @page_depth, @print).reviews
    diagnostics[:rt_time] = Time.new - start_time; start_time = Time.new

    return [diagnostics, reviews] if include_diagnostics
    return reviews
  end

  private
    def source_urls
      GoogleAjax.referrer = "www.resco.re"
      {
        metacritic_title_url: GoogleAjax::Search.web(@film_title + " metacritic")[:results][0][:unescaped_url],
        amazon_title_url: GoogleAjax::Search.web(@film_title + " amazon.com customer reviews")[:results][0][:unescaped_url],
        imdb_title_url: GoogleAjax::Search.web(@film_title + " imdb")[:results][0][:unescaped_url],
        rotten_title_url: GoogleAjax::Search.web(@film_title + " rotten tomatoes")[:results][0][:unescaped_url]
      }
    end
end

r = ReviewAggregator.new('avatar 2009').reviews

binding.pry
