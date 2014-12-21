require 'nokogiri'
require 'open-uri'

class Imdb_Scraper
  def initialize(title_url, user_agent, max_pages = 5, print = true)
    @user_agent = user_agent
    @max_pages = max_pages
    @title_url = title_url
    @print = print
  end

  def reviews
    reviews = []
    review_urls(@title_url).each do |url|
      if url.class == String
        print "Fetching: #{url}... " if @print
        doc = Nokogiri::HTML(open(url, 'User-Agent' => @user_agent).read)
        puts "done" if @print
      else
        doc = url
      end
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
        review[:source] = {vendor: 'imdb', url: @title_url}
        reviews << review
      end
    end
    reviews
  end

  private
    def first_page(review_url)
      print "Fetching: #{review_url}... " if @print
      doc = Nokogiri::HTML(open(review_url, 'User-Agent' => @user_agent).read)
      puts "done" if @print
      pages = doc.css('#tn15content table')[1].css('td').first.text.gsub(':','')[/\d+$/].to_i
      pages = @max_pages if pages > @max_pages
      pages -= 1 # we get the first page here ^
      [pages, doc] # mega hack
    end

    def review_urls(title_url)
      review_url = title_url + "reviews"
      page_count, page = first_page(review_url)
      start = 10; urls = [page]
      page_count.times do
        urls << "#{review_url}?start=#{start}"
        start += 10
      end
      urls
    end

    def evaluate_useful(useful_string)
      pair = useful_string.scan(/\d+/).map {|e| e.to_i }
    end

    def evaluate_rating(rating_string)
      rating_string.split('/').map {|e| e.to_f }.reduce(:/).round(5)
    end
end
