require 'nokogiri'
require 'open-uri'
require 'securerandom'
require 'pry'

FILM_SLUG = 'the-lord-of-the-rings-the-return-of-the-king'
USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
OUTPUT_FOLDER = 'movie'

xml = Nokogiri::HTML(open("http://www.metacritic.com/movie/#{FILM_SLUG}/user-reviews?sort-by=most-helpful&num_items=100", 'User-Agent' => USER_AGENT).read)

xml.css('.critic_reviews_module').first.remove

xml.css('.review').each do |review|
  total_ups = review.css('.total_ups').first.text.to_f
  total_thumbs = review.css('.total_thumbs').first.text.to_i
  quality_score = total_ups / total_thumbs

  if quality_score.to_s.include? 'NaN'
    quality_score = 0
  end

  user_score = review.css('.review_grade').first.text.gsub(/\s/,"").to_i

  review_text = ""
  if review.css('.review_body .blurb').size > 0
    review.css('.review_body .blurb').each do |blurb|
      review_text += blurb.text.gsub(/\s+/," ")
    end
  else
    review_text = review.css('.review_body').text.gsub(/\s+/," ")
  end

  File.open("reviews/#{OUTPUT_FOLDER}/#{SecureRandom.hex[0..10]}.txt", 'w') { |file|
    file.write("#{user_score}\n#{quality_score}\n#{review_text}")
  }
end



