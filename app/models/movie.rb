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
    topics_sentiment  = Hash[ASPECTS.map {|k,v| [k, []]}]
    people_sentiment  = {}
    average_sentiment = []
    sentiment_averages = [] #this is review level
    reviews.each do |review|
      next if review[:rescore_review].nil? || review[:rescore_review].empty?
      sentiment_average = 0
      review[:rescore_review].each do |sentence|
        average_sentiment << sentence[:sentiment]
        sentiment_average += sentence[:sentiment]
        sentence[:context_tags].keys.each do |tag|
          topics_sentiment[tag] << sentence[:sentiment] * sentence[:context_tags][tag]
        end
        sentence[:people_tags].each do |tag|
          people_sentiment[tag] = [] if people_sentiment[tag].nil?
          people_sentiment[tag] << sentence[:sentiment]
        end
      end
      sentiment_average /= review[:rescore_review].size
      sentiment_averages << sentiment_average
    end

    topics_sentiment = topics_sentiment.map { |k, v| [k, v.reduce(:+) / v.size] }
    people_sentiment = people_sentiment.sort_by { |_, v| v.size }
    people_sentiment = people_sentiment.
      map { |k, v| [k, v.reduce(:+) / v.size, v.size] }.reverse.
      reject { |_, _, c| c < 3}.
      sort_by { |_, v, c| (v * 100).to_f / c }.reverse

    average_sentiment = dup_hash(average_sentiment.map {|x| x.round(1)}).to_a.sort_by { |x| x[0] }
    mean = average_sentiment.map { |x| x[0] }.mean
    standard_deviation = average_sentiment.map { |x| x[0] }.standard_deviation
    average_sentiment.map! { |x| [((x[0] - mean) / standard_deviation).round(2), x[1]] }
    labels = [0, average_sentiment.size - 1, average_sentiment.size / 2, average_sentiment.size / 4, average_sentiment.size - average_sentiment.size / 4]
    average_sentiment.each_with_index do |x, i|
      average_sentiment[i] = ['', x[1]] unless labels.include? i
    end

    distribution_stats = [sentiment_averages.max - sentiment_averages.min, sentiment_averages.standard_deviation]

    # collect locations and average sentiment
    location_sentiment = reviews.map {|x| [x[:location], x[:rescore_review].map {|x| x[:sentiment]}.mean]}
    # reject inappropriate locations
    location_sentiment.reject! { |e| e.first == '' || e.first.nil? }
    # group locations and select groups greater than one in size
    location_sentiment = location_sentiment.group_by { |e| e[0]}.to_a.select { |e| e[1].size > 1 }
    # order and calculate scores for groups, sort groups by size
    location_sentiment = location_sentiment.map { |e| [e[0], e[1].map { |e2| e2[1] }.reduce(:+), e[1].size ] }.sort_by { |e| e[1] }.reverse
    # tidy names and score values
    location_sentiment = location_sentiment.map { |e| [e[0].gsub('from ', ''), e[1].round(2) * 100, e[2]] }

    {
      topics: topics_sentiment,
      people: people_sentiment,
      distribution: average_sentiment,
      location: location_sentiment,
      distribution_stats: distribution_stats
    }
  end

  def set_stats
    s = StatCalculator.new(reviews)
    {topic_counts: s.topic_counts, rating_distribution: s.rating_distribution}
  end

  def self.summarized
    all.reject { |movie| movie.stats.empty? }
  end

  def self.review_count
    Movie.pluck(:reviews).map { |reviews| reviews.size }.reduce(:+)
  end

  def self.latest
    order('created_at DESC').limit(1).select('id, title, image_url, year, genres, related_people, sentiment, stats, updated_at, created_at').first
  end

  def self.fast_find(id)
    where(id: id).select('id, title, image_url, year, genres, related_people, sentiment, stats, updated_at, created_at').first
  end

  private
    def dup_hash(ary)
     ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select {
     |k,v| v > 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
    end
end
