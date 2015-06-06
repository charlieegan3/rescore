class Movie < ActiveRecord::Base
  validates_uniqueness_of :rotten_tomatoes_id
  validates_uniqueness_of :title

  serialize :related_people, Hash
  serialize :genres, Array
  serialize :references, Array
  serialize :sentiment, Hash
  serialize :stats, Hash

  before_validation :set_slug if :title_changed?
  after_destroy { Statistic.delay.refresh }
  after_save { Statistic.delay.refresh if self.complete? }

  def build
    update_attributes(SourceSearcher.new(title, year).links)
    raw_reviews = ReviewCollector.new(source_links, page_depth).reviews

    update_attributes({
      references: raw_reviews.map { |r| r[:source][:url] }.uniq,
      review_count: raw_reviews.size,
      related_people: PeopleSearcher.new(rotten_tomatoes_id).people,
      status: '50%',
    })

    reviews = RescoreReviewer.new(raw_reviews, related_people).rescored_reviews
    update_attributes({
      sentiment: SentimentCalculator.new(reviews).build,
      stats: StatCalculator.new(reviews).build,
    })

    Statistic.refresh
    update_attributes({status: nil, complete: true})
  end
  handle_asynchronously :build

  def set_slug
    self.slug = self.title.parameterize
  end

  def to_param
    self.slug
  end

  def source_links
    {
      imdb_link: imdb_link,
      amazon_link: amazon_link,
      metacritic_link: metacritic_link,
      rotten_tomatoes_link: rotten_tomatoes_link
    }
  end

  def source_link_count
    [imdb_link, amazon_link, metacritic_link, rotten_tomatoes_link].count {|l| l.include?('http')}
  end

  def self.summarized
    all.reject { |movie| movie.stats.empty? }
  end

  def self.complete
    Movie.where(:complete => true)
  end

  def self.review_count
    Movie.complete.pluck(:review_count).reduce(:+)
  end

  def self.variation
    count = Movie.complete.size
    return 0 if count == 0
    Movie.complete.pluck(:sentiment).map{ |e| e[:distribution_stats][:st_dev]}.reduce(:+) / count
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
    complete.order('created_at DESC').limit(1).first
  end
end
