require 'nokogiri'
require 'open-uri'
require 'pry'

FILM_SLUG = 'the-lord-of-the-rings-the-return-of-the-king'
USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"

xml = Nokogiri::HTML(open("http://www.metacritic.com/movie/#{FILM_SLUG}/user-reviews?sort-by=most-helpful&num_items=100", 'User-Agent' => USER_AGENT).read)

xml.css('.review').each do |review|
  p review.css('.total_ups').first.text
  p review.css('.total_thumbs').first.text

  p review.css('.review_grade').first.text.gsub(/\s/,"")

  if review.css('.review_body .blurb').size > 0
    review.css('.review_body .blurb').each do |blurb|
      p blurb.text.gsub(/\s+/," ")
    end
  else
    p review.css('.review_body').text.gsub(/\s+/," ")
  end

  gets
end



