require 'nokogiri'
require 'open-uri'
require 'securerandom'
require 'pry'

USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
PAGES = ['http://www.amazon.com/The-Lord-Rings-Return-King/product-reviews/B0039Q4FBW/ref=cm_cr_pr_top_link_1?ie=UTF8&showViewpoints=0&sortBy=byRankDescending',
  'http://www.amazon.com/The-Lord-Rings-Return-King/product-reviews/B0039Q4FBW/ref=cm_cr_pr_top_link_2?ie=UTF8&pageNumber=2&showViewpoints=0&sortBy=byRankDescending']
OUTPUT_FOLDER = 'movie'

divs = []
PAGES.each do |url|
  xml = Nokogiri::HTML(open(url, 'User-Agent' => USER_AGENT).read)
  divs << xml.css('div').to_a
end
divs.flatten!

for i in 0..divs.size - 1
  if divs[i]['class'] == 'reviewText'
    related_facts = divs[i - 10, 12].to_a
    related_facts.select! { |e| (e.text.include? 'out of 5 stars') || (e.text.include? 'found the following review') }
    related_facts.reject! { |e| e.text.length > 400 }
    related_facts.map! { |f| f.text.gsub(/\s+/," ") }

    user_score = related_facts.last.match(/\d.\d{1,} out of \d{1,}/).to_s.split(" out of ").map { |x| x.to_f }.first
    quality_score = related_facts.first.match(/\d{1,} of \d{1,}/).to_s.split(" of ").map { |x| x.to_f }.inject(:/)

    File.open("reviews/#{OUTPUT_FOLDER}/#{SecureRandom.hex[0..10]}.txt", 'w') { |file|
      file.write("#{user_score}\n#{quality_score}\n#{divs[i].text}")
    }
  end
end