class Movie < ActiveRecord::Base
  has_many :favorites

  serialize :reviews, Array
  serialize :related_people, Hash
  serialize :genres, Array
  serialize :references, Array
  serialize :sentiment, Hash
  serialize :stats, Hash

  before_save :default_values
  before_validation :set_slug if :title_changed?
  after_destroy { Statistic.delay.refresh }
  after_save { Statistic.delay.refresh }

  def set_slug
    self.slug = self.title.parameterize
  end

  def to_param
    self.slug
  end

  def default_values
    reviews ||= []
    related_people ||= {}
  end

  def populate_source_links
    s = SourceSearcher.new(title, year)
    update_attributes({
      metacritic_link: s.metacritic_link,
      amazon_link: s.amazon_link,
      imdb_link: s.imdb_link,
      rotten_tomatoes_link: s.rotten_tomatoes_link
    })
  end

  def collect_reviews
    r = ReviewCollector.new(title, page_depth)
    update_attributes({reviews: [], status: '0%'})
    update_attributes({reviews: reviews + r.metacritic_reviews(metacritic_link), status: '25%'})
    update_attributes({reviews: reviews + r.amazon_reviews(amazon_link), status: '50%'})
    update_attributes({reviews: reviews + r.imdb_reviews(imdb_link), status: '75%'})
    update_attributes({reviews: reviews + r.rotten_tomatoes_reviews(rotten_tomatoes_link), status: '100%'})
    update_attributes({references: reviews.map { |r| r[:source][:url] }.uniq, status: nil})
  end
  handle_asynchronously :collect_reviews

  def populate_related_people
    p = PeopleSearcher.new(rotten_tomatoes_id)
    update_attribute(:related_people, {cast: p.cast, directors: p.directors})
  end

  def build_summary
    r = RescoreReviewer.new(self)
    update_attribute(:reviews, r.rescored_reviews)
    update_attributes({
      sentiment: set_sentiment, stats: set_stats, status: nil, task: nil, complete: true
    })
    Statistic.refresh
  end
  handle_asynchronously :build_summary

  def source_link_count
    [imdb_link, amazon_link, metacritic_link, rotten_tomatoes_link].count {|l| l.include?('http')}
  end

  def busy
    !status.nil?
  end

  def has_summary
    !reviews.last[:rescore_review].nil?
  end

  def set_sentiment
    s = SentimentCalculator.new(reviews)
    s.build
    {
      topics: s.topics_sentiment,
      people: s.people_sentiment,
      distribution: s.sentence_sentiment,
      location: s.location_sentiment,
      distribution_stats: s.review_sentiment
    }
  end

  def set_stats
    s = StatCalculator.new(reviews)
    {topic_counts: s.topic_counts, rating_distribution: s.rating_distribution, review_count: s.review_count}
  end

  def complete?
    return self.stats.present?
  end

  def self.summarized
    all.reject { |movie| movie.stats.empty? }
  end

  def self.complete
    Movie.where(:complete => true)
  end

  def self.review_count
    Movie.complete.pluck(:reviews).inject(0) { |sum, e| sum += e.size }
  end

  def self.variation
    Movie.complete.pluck(:sentiment).map{ |e| e[:distribution_stats][:st_dev]}.reduce(:+) / Movie.count
  end

  def self.topic_counts
    {}.tap do |counts|
      Movie.complete.pluck(:stats).each do |stats|
        counts.merge!(stats[:topic_counts]) { |k, a, b| a + b }
      end
    end
  end

  def self.topic_sentiments
    {}.tap do |counts|
      Movie.complete.pluck(:sentiment).each do |sentiments|
        counts.merge!(Hash[sentiments[:topics]]) { |k, a, b| a + b }
      end
    end
  end

  def self.people_count
    Movie.complete.pluck(:related_people).inject([]) do  |people, list|
      people += list[:cast] + list[:directors]
    end.map {|x| x[:name]}.uniq.size
  end

  def self.latest
    columns = Movie.attribute_names - ['reviews']
    complete.order('created_at DESC').limit(1).select(columns).first
  end

  def self.find(input, include_reviews = true)
    param = input.to_i == 0 ? {slug: input} : {id: input}
    if include_reviews
      where(param).first
    else
      where(param).select(Movie.attribute_names - ['reviews']).first
    end
  end
end
