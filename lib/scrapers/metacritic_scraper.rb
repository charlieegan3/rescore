require 'nokogiri'
require 'open-uri'

class MetacriticScraper
  def initialize(title_url, user_agent, max_pages = 5, print = true)
    @user_agent = user_agent
    @max_pages = max_pages - 1 # 0 index
    @title_url = title_url
    @print = print
  end

  def reviews
    return [] if @title_url == '' || @title_url.nil?
    reviews = []
    review_urls(@title_url).each do |review_url|
      raw_reviews(review_url).each do |raw_review|
        review = {}
        review[:rating] = raw_review.css('.review_grade').first.text.gsub(/\s/,"").to_i
        review[:percentage] = ((review[:rating].to_f / 10.0) * 100).round(2)
        review[:content] = extract_content(raw_review)
        review[:useful] = evaluate_useful(raw_review)
        review[:username] = raw_review.css('.name').text.strip
        review[:date] = raw_review.css('.date').text.strip
        review[:location] = nil
        review[:title] = nil
        review[:source] = {vendor: 'metacritic', url: @title_url}
        reviews << review
      end
    end
    reviews
  end

  private
    def page_count(review_url)
      print "Fetching: #{review_url}... " if @print
      doc = Nokogiri::HTML(open(review_url, 'User-Agent' => @user_agent).read)
      puts "done" if @print
      pages = doc.css('#tn15content table')[1].css('td').first.text.gsub(':','')[/\d+$/].to_i
      pages = @max_pages if pages > @max_pages
    end

    def review_urls(title_url)
      review_url = title_url + '/user-reviews'
      print "Fetching: #{review_url}... " if @print
      doc = Nokogiri::HTML(open(review_url, 'User-Agent' => @user_agent).read)
      puts "done" if @print
      total_pages = doc.css('.page.last_page').text.to_i
      total_pages = @max_pages if total_pages > @max_pages

      urls = []
      for i in 0..@max_pages
        urls << review_url + "?num_items=100&page=#{i}"
      end
      urls
    end

    def raw_reviews(review_url)
      print "Fetching: #{review_url}... " if @print
      xml = Nokogiri::HTML(open(review_url, 'User-Agent' => @user_agent).read)
      puts "done" if @print
      xml.css('.critic_reviews_module').first.remove
      xml.css('.review').to_a
    end

    def evaluate_useful(raw_review)
      total_ups = raw_review.css('.total_ups').first
      return if total_ups.nil?
      total_ups = total_ups.text.to_f
      total_thumbs = raw_review.css('.total_thumbs').first.text.to_i
      [total_ups, total_thumbs]
    end

    def extract_content(raw_review)
      content = ""
      if raw_review.css('.review_body .blurb').size > 0
        raw_review.css('.review_body .blurb').each do |blurb|
          content += blurb.text.gsub(/\s+/," ")
        end
      else
        content = raw_review.css('.review_body').text.gsub(/\s+/," ")
      end
      content
    end
end
