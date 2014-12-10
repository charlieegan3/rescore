require 'nokogiri'
require 'open-uri'

class RtScraper
  def initialize(title_url, max_pages = 5)
    @user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2'
    @max_pages = max_pages
    @title_url = title_url
  end

  def reviews
    rows = []
    review_urls(@title_url).each do |url|
      doc = Nokogiri::HTML(open(url, 'User-Agent' => @user_agent).read)
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

  private
    def review_urls(title_url)
      review_url = title_url + "reviews/?type=user"
      page = 1; urls = []
      @max_pages.times do
        urls << "#{review_url}&page=#{page}"
        page += 1
      end
      urls
    end
end
