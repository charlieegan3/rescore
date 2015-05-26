class Movie < ActiveRecord::Base
  serialize :related_people, Hash
  serialize :genres, Array
  serialize :references, Array
  serialize :sentiment, Hash
  serialize :stats, Hash

  before_validation :set_slug if :title_changed?
  after_destroy { Statistic.delay.refresh }
  after_save { Statistic.delay.refresh if self.complete? }

  def build
    s = SourceSearcher.new(title, year)
    update_attributes({
      metacritic_link: s.metacritic_link,
      amazon_link: s.amazon_link,
      imdb_link: s.imdb_link,
      rotten_tomatoes_link: s.rotten_tomatoes_link,
      status: '25%',
    })

    review_collector = ReviewCollector.new(page_depth)
    collected_reviews = review_collector.metacritic_reviews(metacritic_link) +
                        review_collector.amazon_reviews(amazon_link) +
                        review_collector.imdb_reviews(imdb_link) +
                        review_collector.rotten_tomatoes_reviews(rotten_tomatoes_link)

    update_attributes({
      review_count: collected_reviews.size,
      references: collected_reviews.map { |r| r[:source][:url] }.uniq,
      status: '50%',
    })

    p = PeopleSearcher.new(rotten_tomatoes_id)
    update_attributes({related_people: {cast: p.cast, directors: p.directors},
                      status: '75%'})

    rescore_reviewer = RescoreReviewer.new(collected_reviews, related_people)
    rescored_reviews = rescore_reviewer.rescored_reviews
    update_attributes({
      sentiment: SentimentCalculator.new(rescored_reviews).build,
      stats: StatCalculator.new(rescored_reviews).build,
    })

    Statistic.refresh
    update_attributes({
      status: nil,
      complete: true
    })
  end
  handle_asynchronously :build

  def set_slug
    self.slug = self.title.parameterize
  end

  def to_param
    self.slug
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
