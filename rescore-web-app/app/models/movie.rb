class Movie < ActiveRecord::Base
  serialize :reviews, Array

  def populate_source_links
    GoogleAjax.referrer = "www.resco.re"
    update_attribute(:metacritic_link,
      GoogleAjax::Search.web(title + " metacritic")[:results][0][:unescaped_url])
    update_attribute(:amazon_link,
      GoogleAjax::Search.web(title + " amazon.com customer reviews")[:results][0][:unescaped_url])
    update_attribute(:imdb_link,
      GoogleAjax::Search.web(title + " imdb")[:results][0][:unescaped_url])
    update_attribute(:rotten_tomatoes_link,
      GoogleAjax::Search.web(title + " rotten tomatoes")[:results][0][:unescaped_url])
  end

  def collect_reviews
    r = ReviewAggregator.new(title)
    update_attribute(:reviews, [])
    self.reviews += r.metacritic_reviews(metacritic_link)
    self.reviews += r.amazon_reviews(amazon_link)
    self.reviews += r.imdb_reviews(imdb_link)
    self.reviews += r.rotten_tomatoes_reviews(rotten_tomatoes_link)
    save
  end
  handle_asynchronously :collect_reviews
end
