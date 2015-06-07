require 'open-uri'

class CoverFinder
  def initialize(rotten_tomatoes_link)
    @url = rotten_tomatoes_link
  end

  def find
    { image_url: Nokogiri::HTML(open(@url).read).at_css('.posterImage')['src'] }
  end
end
