class Movie < ActiveRecord::Base
  serialize :reviews, Array
  serialize :related_people, Hash
  serialize :genres, Array
  serialize :sentiment, Hash
  serialize :stats, Hash

  before_save :default_values
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
    update_attributes({reviews: reviews + r.rotten_tomatoes_reviews(rotten_tomatoes_link), status: nil})
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
      sentiment: set_sentiment, stats: set_stats, status: nil, task: nil
    })
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
    {topic_counts: s.topic_counts, rating_distribution: s.rating_distribution}
  end

  def complete?
    return self.stats.present?
  end

  def self.comparison_summary(movie_one, movie_two)
    m1 = movie_one
    m2 = movie_two
    winners = {:aspect_sentiment => nil, :aspect_focus => nil, :review_range => nil, :review_variation => nil}

    # Aspect sentiment.
    m1.sentiment[:topics].each do |topic|
      if m2.sentiment[:topics][topic[0]] && topic[1] > m2.sentiment[:topics][topic[0]]
        winners[:aspect_sentiment] = m1.title
      end
      if m2.sentiment[:topics][topic[0]] && topic[1] < m2.sentiment[:topics][topic[0]]
        winners[:aspect_sentiment] = m2.title
      end
    end

    # Aspect discussion focus.
    m1.stats[:topic_counts].each do |topic|
      if m2.stats[:topic_counts][topic[0]] && topic[1] > m2.stats[:topic_counts][topic[0]]
        winners[:aspect_focus] = m1.title
      end
      if m2.stats[:topic_counts][topic[0]] && topic[1] < m2.stats[:topic_counts][topic[0]]
        winners[:aspect_focus] = m2.title
      end
    end

    # Review Sentiment distribution and variation.
    if m2.sentiment[:distribution_stats][:range] && m2.sentiment[:distribution_stats][:range] > m1.sentiment[:distribution_stats][:range]
      winners[:review_range] = m2.title
    elsif m2.sentiment[:distribution_stats][:range] && m2.sentiment[:distribution_stats][:range] < m1.sentiment[:distribution_stats][:range]
      winners[:review_range] = m1.title
    else
      winners[:review_range] = :both
    end

    if m2.sentiment[:distribution_stats][:st_dev] && m2.sentiment[:distribution_stats][:st_dev] > m1.sentiment[:distribution_stats][:st_dev]
      winners[:review_variation] = m2.title
    elsif m2.sentiment[:distribution_stats][:st_dev] && m2.sentiment[:distribution_stats][:st_dev] < m1.sentiment[:distribution_stats][:st_dev]
      winners[:review_variation] = m1.title
    else
      winners[:review_variation] = :both
    end

    return winners
  end

  def self.summarized
    all.reject { |movie| movie.stats.empty? }
  end

  def self.review_count
    Movie.all.pluck(:reviews).inject(0) { |sum, e| sum += e.size }
  end

  def self.topic_counts
    {}.tap do |counts|
      Movie.all.pluck(:stats).each do |stats|
        counts.merge!(stats[:topic_counts]) { |k, a, b| a + b }
      end
    end
  end

  def self.topic_sentiments
    {}.tap do |counts|
      Movie.all.pluck(:sentiment).each do |sentiments|
        counts.merge!(Hash[sentiments[:topics]]) { |k, a, b| a + b }
      end
    end
  end

  def self.people_count
    Movie.all.pluck(:related_people).inject([]) do  |people, list|
      people += list[:cast] + list[:directors]
    end.map {|x| x[:name]}.uniq.size
  end

  def self.latest
    order('created_at DESC').limit(1).select('id, title, image_url, year, genres, related_people, sentiment, stats, updated_at, created_at').first
  end

  def self.fast_find(id)
    where(id: id).select('id, title, image_url, year, genres, related_people, sentiment, stats, updated_at, created_at').first
  end
end
