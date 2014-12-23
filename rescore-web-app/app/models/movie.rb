class Movie < ActiveRecord::Base
  serialize :reviews, Array
  serialize :related_people, Hash

  before_save :default_values
  def default_values
    self.reviews ||= []
    self.related_people ||= {}
  end

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
  handle_asynchronously :collect_reviews

  def populate_related_people
    bf = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
    cast = bf.movies.search_by_id(self.rotten_tomatoes_id).full_cast.map { |person|
      {name: person.name, characters: person.characters}
    }
    update_attribute(:related_people, {cast: cast})
  end

  def build_summary
    summary = []
    count = 0
    self.reviews.each do |review|
      puts self.status = "#{(((count += 1).to_f / self.reviews.size) * 100).floor}%"; save
      rescore_review = RescoreReview.new(review[:content], self.related_people)
      rescore_review.build_all
      review[:rescore_review] = rescore_review.sentences
      summary << review
    end
    self.reviews = summary
    self.status = nil
    save
  end
  handle_asynchronously :build_summary

  def rating_distribution
    counts = []
    rounded_ratings = self.reviews.map {|x| (x[:percentage] / 10 unless x[:percentage].nil?).to_i * 10 }
    (0..100).step(10) do |n|
      counts << rounded_ratings.count(n)
    end
    counts
  end

  private
    def dup_hash(ary)
     ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select {
     |k,v| v > 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
    end
end
