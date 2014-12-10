require 'nokogiri'
require 'open-uri'

class AmazonScraper
  def initialize(title_url, user_agent, max_pages = 5, print = true)
    @user_agent = user_agent
    @max_pages = max_pages
    @title_url = title_url
    @title_url.gsub!('/dp/', '/product-reviews/')unless @title_url.include?('product-reviews')
    @print = print
  end

  def reviews
    potential_review_divs = get_potential_reviews

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
      review[:source] = {vendor: 'amazon', url: @title_url}
      reviews << review
    end
    reviews
  end

  private
    def get_potential_reviews
      potential_review_divs = []
      review_urls(@title_url).each do |url|
        print "Fetching: #{url}... " if @print
        page_divs = Nokogiri::HTML(open(url, 'User-Agent' => @user_agent).read).css('div').to_a
        puts "done" if @print
        page_divs.map { |div| potential_review_divs << div }
      end
      potential_review_divs
    end

    def get_paging_info(review_url)
      last_page = nil
      count = 0
      loop do
        print "Fetching: #{review_url}... " if @print
        doc = Nokogiri::HTML(open(review_url, 'User-Agent' => @user_agent).read)
        puts "done" if @print
        last_page = doc.css('.paging a')[-2]
        break unless last_page.nil?
        puts "Amazon failed, retrying..." if @print
        count += 1
        raise if count > 10
      end
      [last_page.text.to_i, last_page['href']]
    end

    def review_urls(review_url)
      total_pages, url = get_paging_info(review_url)
      pages = total_pages
      pages = @max_pages if pages > @max_pages

      urls = []
      for i in 1..pages
        urls << url.gsub("pageNumber=#{total_pages}", "pageNumber=#{i}")
      end
      urls
    end
end
