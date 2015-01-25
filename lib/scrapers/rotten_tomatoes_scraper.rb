require 'nokogiri'
require 'open-uri'

class Rotten_Tomatoes_Scraper
  def initialize(title_url, user_agent, max_pages = 5, print = true)
    @user_agent = user_agent
    @max_pages = max_pages
    @title_url = title_url
    @print = print
  end

  def reviews
    return [] if @title_url == '' || @title_url.nil?
    rows = []
    review_urls(@title_url).each do |url|
      print "Fetching: #{url}... " if @print
      doc = Nokogiri::HTML(open(url, 'User-Agent' => @user_agent).read)
      puts "done" if @print
      rows += doc.css('.table-striped tr')
    end
    reviews = []
    rows.each do |row|
      review = {}
      review[:username] = row.css('td')[1].text.strip
      useful = row.css('td')[2].text.strip
      review[:useful] = useful if useful == 'Super Reviewer'
      review[:date] = row.css('.fr.small.subtle').text
      review[:rating] = row.css('.fl .glyphicon-star').size
      review[:percentage] = ((review[:rating].to_f / 5.0) * 100).round(2)
      if row.css('.fl').text.strip == '½'
        review[:rating] += 0.5
      end
      review[:content] = row.css('.user_review').first.text.strip
      # comply with the format
      review[:title], review[:location] = nil, nil
      review[:source] = {vendor: 'rotten_tomatoes', url: @title_url}
      reviews << review
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
