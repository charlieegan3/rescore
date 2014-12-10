require_relative 'amazon_scraper'
require_relative 'rt_scraper'
require_relative 'metacritic_scraper'
require_relative 'imdb_scraper'

require 'googleajax'
require 'open-uri'

GoogleAjax.referrer = "www.resco.re"

film_title = "The Hobbit: An Unexpected Journey"

puts metacritic_title_url = GoogleAjax::Search.web(film_title + " metacritic")[:results][0][:unescaped_url]
puts amazon_title_url = GoogleAjax::Search.web(film_title + " amazon.com product reviews")[:results][0][:unescaped_url]
puts imdb_title_url = GoogleAjax::Search.web(film_title + " imdb")[:results][0][:unescaped_url]
puts rotten_title_url = GoogleAjax::Search.web(film_title + " rotten tomatoes")[:results][0][:unescaped_url]

p MetacriticScraper.scrape_reviews(metacritic_title_url).size
p AmazonScraper.scrape_reviews(amazon_title_url).size
p IMDbScraper.scrape_reviews(imdb_title_url).size
p RtScraper.scrape_reviews(rotten_title_url).size
