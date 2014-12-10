require 'nokogiri'
require 'open-uri'

class RtScraper
  def initialize(title_url, user_agent, max_pages = 5, print = true)
    @user_agent = user_agent
    @max_pages = max_pages
    @title_url = title_url
    @print = print
  end

  def reviews
    rows = []
    review_urls(@title_url).each do |url|
      print "Fetching: #{url}... " if @print
      doc = Nokogiri::HTML(open(url, 'User-Agent' => @user_agent).read)
      puts "done" if @print
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
