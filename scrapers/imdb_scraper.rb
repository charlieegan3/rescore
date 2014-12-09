require 'nokogiri'
require 'open-uri'

module IMDbScraper
  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
  MAX_PAGES = 1

  def self.page_count(review_url)
    doc = Nokogiri::HTML(open(review_url, 'User-Agent' => USER_AGENT).read)
    pages = doc.css('#tn15content table')[1].css('td').first.text.gsub(':','')[/\d+$/].to_i
    pages = MAX_PAGES if pages > MAX_PAGES
  end

  def self.review_urls(title_url)
    review_url = title_url + "reviews"
    start = 0; urls = []
    page_count(review_url).times do
      urls << "#{review_url}?start=#{start}"
      start += 10
    end
    urls
  end

  def self.evaluate_useful(useful_string)
    pair = useful_string.scan(/\d+/).map {|e| e.to_i }
  end

  def self.evaluate_rating(rating_string)
    rating_string.split('/').map {|e| e.to_f }.reduce(:/).round(5)
  end

  def self.scrape_reviews(title_url)
    reviews = []
    review_urls(title_url).each do |url|
      doc = Nokogiri::HTML(open(url, 'User-Agent' => USER_AGENT).read)
      1.step(19, 2) do |i|
        review = {}
        rating = doc.xpath("//div[@id='tn15content']/div[#{i}]/img")
        unless rating.empty?
          review[:rating] = evaluate_rating(rating.attr('alt').text)
        else
          review[:rating] = nil
        end
        review[:useful] = evaluate_useful(doc.xpath("//div[@id='tn15content']/div[#{i}]/small[1]").text)
        review[:title] = doc.xpath("//div[@id='tn15content']/div[#{i}]/h2").text
        review[:username] = doc.xpath("//div[@id='tn15content']/div[#{i}]/a[2]")[0].child.to_s
        review[:location] = doc.xpath("//div[@id='tn15content']/div[#{i}]/small[2]")[0].child.to_s
        review[:date] = doc.xpath("//div[@id='tn15content']/div[#{i}]/small[3]").text
        review[:content] = doc.xpath("//div[@id='tn15content']//p[#{(i.to_f/2).ceil.to_i}]").text
        reviews.push(review)
      end
    end
    reviews
  end
end
