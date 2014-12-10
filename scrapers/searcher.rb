require_relative 'scrapers/amazon_scraper'
require_relative 'scrapers/rt_scraper'
require_relative 'scrapers/metacritic_scraper'
require_relative 'scrapers/imdb_scraper'

require 'googleajax'
require 'open-uri'

GoogleAjax.referrer = "www.resco.re"

film_title = "Avatar 2009"

puts metacritic_title_url = GoogleAjax::Search.web(film_title + " metacritic")[:results][0][:unescaped_url]
puts amazon_title_url = GoogleAjax::Search.web(film_title + " amazon.com customer reviews")[:results][0][:unescaped_url]
puts imdb_title_url = GoogleAjax::Search.web(film_title + " imdb")[:results][0][:unescaped_url]
puts rotten_title_url = GoogleAjax::Search.web(film_title + " rotten tomatoes")[:results][0][:unescaped_url]

user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2'
page_depth = 1
print = true
reviews = []

reviews += MetacriticScraper.new(metacritic_title_url, user_agent, page_depth, print).reviews
reviews += AmazonScraper.new(amazon_title_url, user_agent, page_depth, print).reviews
reviews += IMDbScraper.new(imdb_title_url, user_agent, page_depth, print).reviews
reviews += RtScraper.new(rotten_title_url, user_agent, page_depth, print).reviews

puts "Total: #{reviews.size} reviews"
