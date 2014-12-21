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
    self.status = 'Starting review collection...'; save
    r = ReviewAggregator.new(title, self.page_depth)
    update_attribute(:reviews, [])
    self.status = 'Collecting Metacritic reviews...'; save
    self.reviews += r.metacritic_reviews(metacritic_link)
    self.status = 'Collecting Amazon reviews...'; save
    self.reviews += r.amazon_reviews(amazon_link)
    self.status = 'Collecting IMDb reviews...'; save
    self.reviews += r.imdb_reviews(imdb_link)
    self.status = 'Collecting Rotten Tomatoes reviews...'; save
    self.reviews += r.rotten_tomatoes_reviews(rotten_tomatoes_link)
    self.status = nil; save
    save
  end

  def rating_distribution
    dup_hash(self.reviews.map {|x| (x[:percentage] / 10 unless x[:percentage].nil?).to_i * 10 }).to_a.
      sort_by {|x|x.first}.map {|x|
      x.last
    }
  end

  private
    def dup_hash(ary)
     ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select {
     |k,v| v > 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
    end
  handle_asynchronously :collect_reviews
end
