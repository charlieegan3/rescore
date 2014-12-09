require 'nokogiri'
require 'open-uri'

module MetacriticScraper
  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
  MAX_PAGES = 3
  def page_count(review_url)
    doc = Nokogiri::HTML(open(review_url, 'User-Agent' => USER_AGENT).read)
    pages = doc.css('#tn15content table')[1].css('td').first.text.gsub(':','')[/\d+$/].to_i
    pages = MAX_PAGES if pages > MAX_PAGES
  end

  def review_urls(title_url)
    review_url = title_url + '/user-reviews'
    doc = Nokogiri::HTML(open(review_url, 'User-Agent' => USER_AGENT).read)
    total_pages = doc.css('.page.last_page').text.to_i
    total_pages = MAX_PAGES if total_pages > MAX_PAGES

    urls = []
    for i in 0..MAX_PAGES
      urls << review_url + "?num_items=100&page=#{i}"
    end
    urls
  end

  def raw_reviews(review_url)
    xml = Nokogiri::HTML(open(review_url, 'User-Agent' => USER_AGENT).read)
    xml.css('.critic_reviews_module').first.remove
    xml.css('.review').to_a
  end

  def evaluate_useful(raw_review)
    total_ups = raw_review.css('.total_ups').first.text.to_f
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

  def scrape_reviews(title_url)
    reviews = []

    review_urls(title_url).each do |review_url|
      raw_reviews(review_url).each do |raw_review|
        review_hash = {}
        review_hash[:rating] = raw_review.css('.review_grade').first.text.gsub(/\s/,"").to_i
        review_hash[:content] = extract_content(raw_review)
        review_hash[:useful] = evaluate_useful(raw_review)
        review_hash[:username] = raw_review.css('.name').text.strip
        review_hash[:date] = raw_review.css('.date').text.strip
        review_hash[:location] = nil
        review_hash[:title] = nil
        reviews.push(review_hash)
      end
    end
    reviews
  end
end
