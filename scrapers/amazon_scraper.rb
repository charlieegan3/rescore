require 'nokogiri'
require 'open-uri'

module AmazonScraper
  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
  MAX_PAGES = 1

  def self.get_paging_info(review_url)
    last_page = nil
    count = 0
    loop do
      doc = Nokogiri::HTML(open(review_url, 'User-Agent' => USER_AGENT).read)
      last_page = doc.css('.paging a')[-2]
      break unless last_page.nil?
      puts "Amazon failed, retrying..."
      count += 1
      raise if count > 10
    end
    [last_page.text.to_i, last_page['href']]
  end

  def self.review_urls(review_url)
    total_pages, url = get_paging_info(review_url)
    pages = total_pages
    pages = MAX_PAGES if pages > MAX_PAGES

    urls = []
    for i in 1..pages
      urls << url.gsub("pageNumber=#{total_pages}", "pageNumber=#{i}")
    end
    urls
  end

  def self.scrape_reviews(review_url)
    potential_review_divs = []
    review_urls(review_url).each do |url|
      page_divs = Nokogiri::HTML(open(url, 'User-Agent' => USER_AGENT).read).css('div').to_a
      page_divs.map { |div| potential_review_divs << div }
    end

    reviews = []
    for i in 0..potential_review_divs.size - 1
      next if potential_review_divs[i]['class'] != 'reviewText'
      review = {}
      domain = potential_review_divs[i - 10, 12].to_a
      domain.select! { |e| (e.text.include? 'out of 5 stars') || (e.text.include? 'found the following review') }
      domain.reject! { |e| e.text.length > 400 }
      domain.map! { |f| f.text.gsub(/\s+/," ") }

      review[:content] = potential_review_divs[i].text
      review[:rating] = domain.last.match(/\d.\d{1,} out of \d{1,}/).to_s.split(" out of ").map { |x| x.to_f }.first
      review[:useful] = domain.first.split('people').first.strip.split(' of ').map {|x| x.gsub(',','').to_i }
      review[:date] = domain.last.split(',').reverse.take(2).join('').gsub(/\s+/, ' ')
      review[:title] = domain.last.split('stars').last.split(',').first.strip

      name_location = nil
      i.downto(i-10).each do |j|
        if potential_review_divs[j].text.include?('See all my reviews')
          name_location = j
          break
        end
      end

      if name_location
        name_location = potential_review_divs[name_location].text.split('  - See all my reviews').first
        review[:location] = name_location.match(/\(.*\)/).to_s
        review[:username] = name_location.gsub(review[:location], '').strip
      else
        review[:username] = nil
        review[:location] = nil
      end
      reviews << review
    end
    reviews
  end
end
