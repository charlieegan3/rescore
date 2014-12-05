require 'googleajax'
require 'open-uri'

GoogleAjax.referrer = "www.resco.re"

film_title = "The Hobbit: An Unexpected Journey"

p GoogleAjax::Search.web(film_title + " imdb")[:results][0][:unescaped_url]
p GoogleAjax::Search.web(film_title + " rotten tomatoes")[:results][0][:unescaped_url]
p GoogleAjax::Search.web(film_title + " metacritic")[:results][0][:unescaped_url]
p GoogleAjax::Search.web(film_title + " amazon.com product reviews")[:results][0][:unescaped_url]
p GoogleAjax::Search.web(film_title + " empire.com review")[:results][0][:unescaped_url]
