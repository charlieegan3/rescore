require 'nokogiri'
require 'open-uri'

module RtScraper
  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
  MAX_PAGES = 1

  def page_count(review_url)
    MAX_PAGES
  end

  def review_urls(title_url)
    review_url = title_url + "reviews/?type=user"
    page = 1; urls = []
    page_count(review_url).times do
      urls << "#{review_url}&page=#{page}"
      page += 1
    end
    urls
  end

  def scrape_reviews(title_url)
    rows = []
    review_urls(title_url).each do |url|
      doc = Nokogiri::HTML(open(url, 'User-Agent' => USER_AGENT).read)
      rows += doc.css('.table-striped tr')
    end
    reviews = []
    rows.each do |row|
      review_hash = {}
      review_hash[:name] = row.css('td')[1].text.strip
      useful = row.css('td')[2].text.strip
      review_hash[:useful] = useful if useful == 'Super Reviewer'
      review_hash[:date] = row.css('.fr.small.subtle').text
      review_hash[:rating] = row.css('.fl .glyphicon-star').size
      if row.css('.fl').text.strip == '½'
        review_hash[:rating] += 0.5
      end
      review_hash[:content] = row.css('.user_review').first.text.strip
      reviews << review_hash
    end
    reviews
  end
end
