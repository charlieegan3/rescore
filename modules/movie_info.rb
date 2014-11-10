module MovieInfo

  # | ------------------------------------------------------------------------
  # | ABOUT:
  # |
  # | get_title() finds the title of a film, given a review.
  # | get_people() finds the cast list and director for a film, given a title.
  # | ------------------------------------------------------------------------

  require 'sentimental'
  require 'ots'
  require 'treat'
  require 'googleajax'
  require 'nokogiri'
  require 'pry'
  require 'sanitize'
  require 'colorize'
  require 'unidecoder'
  require_relative 'BadFruit/lib/badfruit.rb'
  include Treat::Core::DSL

  GoogleAjax.referrer = "hey"

  def MovieInfo.get_title(review)
    o = OTS.parse(review)
    counts = {}
    film = ""

    o.topics.each do |t|
      counts[t] = 0
      review.split("\W").each do |word|
        counts[t] += 1 if word == t
      end
    end

    key = ""
    if review.length < 200
      key = review
    else
      key = review[0..200]
    end

    search = GoogleAjax::Search.web(key)
    title = Sanitize.fragment(search[:results][0][:title])

    return title
  end

  def MovieInfo.get_people(title)
    begin
      bf = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
      query = bf.movies.search_by_name(title[0..15]) # Try to cut out irrelevant bits of string.

      cast = query[0].full_cast
      director = query[0].director
      #reviews = query[0].reviews

    rescue NoMethodError
      puts "No movie found for: ".colorize(:red) + title.colorize(:blue)
      return {:cast => [], :director => []}
    end

    return {:cast => cast, :director => director}
  end

end
