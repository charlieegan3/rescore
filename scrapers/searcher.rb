require_relative 'amazon_scraper'
require_relative 'rt_scraper'
require_relative 'metacritic_scraper'
require_relative 'imdb_scraper'

require 'googleajax'
require 'open-uri'

GoogleAjax.referrer = "www.resco.re"

film_title = "Avatar 2009"

puts metacritic_title_url = GoogleAjax::Search.web(film_title + " metacritic")[:results][0][:unescaped_url]
puts amazon_title_url = GoogleAjax::Search.web(film_title + " amazon.com customer reviews")[:results][0][:unescaped_url]
puts imdb_title_url = GoogleAjax::Search.web(film_title + " imdb")[:results][0][:unescaped_url]
puts rotten_title_url = GoogleAjax::Search.web(film_title + " rotten tomatoes")[:results][0][:unescaped_url]

page_depth = 1
reviews = []

reviews += MetacriticScraper.new(metacritic_title_url, page_depth, false).reviews
reviews += AmazonScraper.new(amazon_title_url, page_depth, false).reviews
reviews += IMDbScraper.new(imdb_title_url, page_depth, false).reviews
reviews += RtScraper.new(rotten_title_url, page_depth, false).reviews

p "Total: #{reviews.size} reviews"
