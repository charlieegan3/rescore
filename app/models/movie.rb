class Movie < ActiveRecord::Base
  serialize :reviews, Array
  serialize :related_people, Hash
  serialize :genres, Array
  serialize :sentiment, Hash
  serialize :stats, Hash

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
    self.status = '0%'; save
    r = ReviewAggregator.new(title, self.page_depth)
    update_attribute(:reviews, [])
    self.status = '20%'; save
    self.reviews += r.metacritic_reviews(metacritic_link)
    self.status = '40%'; save
    self.reviews += r.amazon_reviews(amazon_link)
    self.status = '60%'; save
    self.reviews += r.imdb_reviews(imdb_link)
    self.status = '80%'; save
    self.reviews += r.rotten_tomatoes_reviews(rotten_tomatoes_link)
    self.status = nil; self.task = nil;
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
      rescore_review = RescoreReview.new(review[:content], self.related_people)
      rescore_review.build_all
      review[:rescore_review] = rescore_review.sentences
      summary << review
    end
    self.reviews = summary
    self.status = nil
    self.task = nil
    self.sentiment = set_sentiment
    self.stats = set_stats
    save
  end
  handle_asynchronously :build_summary

  def source_link_count
    [self.imdb_link, self.amazon_link, self.metacritic_link, self.rotten_tomatoes_link].count {|l| l.include?('http')}
  end

  def busy
    !self.status.nil?
  end

  def has_summary
    !self.reviews.last[:rescore_review].nil?
  end

  def set_sentiment
    topics_sentiment  = {}
    people_sentiment  = {}
    date_sentiment = []
    self.reviews.each do |review|
      next if review[:rescore_review].nil?
      sentiment_average = 0
      review[:rescore_review].each do |sentence|
        sentiment_average += sentence[:sentiment][:average]
        sentence[:context_tags].keys.each do |tag|
          topics_sentiment[tag] = [] if topics_sentiment[tag].nil?
          topics_sentiment[tag] << sentence[:sentiment][:average]
        end
        sentence[:people_tags].each do |tag|
          people_sentiment[tag] = [] if people_sentiment[tag].nil?
          people_sentiment[tag] << sentence[:sentiment][:average]
        end
      end
      sentiment_average /= review[:rescore_review].size
      date_sentiment << [Date.parse(review[:date]).to_s, sentiment_average] unless review[:date] == ""
    end

    topics_sentiment = topics_sentiment.map { |k, v| [k, v.reduce(:+) / v.size] }
    people_sentiment = people_sentiment.sort_by { |_, v| v.size }
    people_sentiment = people_sentiment.
      map { |k, v| [k, v.reduce(:+) / v.size, v.size] }.reverse.
      reject { |_, _, c| c < 3}.
      sort_by { |_, v, c| (v * 100).to_f / c }.reverse
    date_sentiment = date_sentiment.sort_by {|date, value| date }

    {topics: topics_sentiment, people: people_sentiment, date: date_sentiment}
  end

  def set_stats
    topic_counts = Hash.new(0)
    self.reviews.each do |review|
      review[:rescore_review].each do |sentence|
        sentence[:context_tags].keys.each do |tag|
          topic_counts[tag] += 1
        end
      end
    end

    rating_distribution = []
    rounded_ratings = self.reviews.map {|x| (x[:percentage] / 10 unless x[:percentage].nil?).to_i * 10 }
    (0..100).step(10) do |n|
      rating_distribution << rounded_ratings.count(n)
    end
    {topic_counts: topic_counts, rating_distribution: rating_distribution}
  end

  private
    def dup_hash(ary)
     ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select {
     |k,v| v > 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
    end
end
