require 'nokogiri'
require 'open-uri'
require 'securerandom'
require 'pry'

USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
PAGES = [
  'http://www.amazon.com/The-Lord-Rings-Return-King/product-reviews/B0039Q4FBW/ref=cm_cr_pr_top_link_1?ie=UTF8&showViewpoints=0&sortBy=byRankDescending',
  'http://www.amazon.com/The-Lord-Rings-Return-King/product-reviews/B0039Q4FBW/ref=cm_cr_pr_top_link_2?ie=UTF8&pageNumber=2&showViewpoints=0&sortBy=byRankDescending'
]
OUTPUT_FOLDER = 'movie'

divs = [].tap do |divs|
  PAGES.each do |url|
    page_divs = Nokogiri::HTML(open(url, 'User-Agent' => USER_AGENT).read).css('div').to_a
    page_divs.map { |div| divs << div }
  end
end

for i in 0..divs.size - 1
  if divs[i]['class'] == 'reviewText'
    domain = divs[i - 10, 12].to_a
    domain.select! { |e| (e.text.include? 'out of 5 stars') || (e.text.include? 'found the following review') }
    domain.reject! { |e| e.text.length > 400 }
    domain.map! { |f| f.text.gsub(/\s+/," ") }

    user_score = domain.last.match(/\d.\d{1,} out of \d{1,}/).to_s.split(" out of ").map { |x| x.to_f }.first
    quality_score = domain.first.match(/\d{1,} of \d{1,}/).to_s.split(" of ").map { |x| x.to_f }.inject(:/)

    File.open("reviews/#{OUTPUT_FOLDER}/#{SecureRandom.hex[0..10]}.txt", 'w') { |file|
      file.write("#{user_score}\n#{quality_score}\n#{divs[i].text}")
    }
  end
end