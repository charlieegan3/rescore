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
    update_attribute(:status, '0%')
    r = ReviewAggregator.new(title, page_depth)
    reviews = []
    update_attribute(:status, '20%')
    reviews += r.metacritic_reviews(metacritic_link)
    update_attribute(:status, '40%')
    reviews += r.amazon_reviews(amazon_link)
    update_attribute(:status, '60%')
    reviews += r.imdb_reviews(imdb_link)
    update_attribute(:status, '80%')
    reviews += r.rotten_tomatoes_reviews(rotten_tomatoes_link)
    update_attribute(:reviews, reviews)
    update_attributes({status: nil, task: nil})
  end
  handle_asynchronously :collect_reviews

  def populate_related_people
    bf = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
    cast = bf.movies.search_by_id(rotten_tomatoes_id).full_cast.map { |person|
      {name: person.name, characters: person.characters}
    }
    update_attribute(:related_people, {cast: cast})
  end

  def build_summary
    summary = []
    sentiment_analyzer = Sentiment::SentimentAnalyzer.new
    reviews.each do |review|
      rescore_review = RescoreReview.new(review[:content], related_people)
      rescore_review.build_all(sentiment_analyzer)
      review[:rescore_review] = rescore_review.sentences
      summary << review
    end
    update_attribute(:reviews, summary)
    update_attributes({sentiment: set_sentiment, stats: set_stats})
    update_attributes({status: nil, task: nil})
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
    topics_sentiment  = {}
    people_sentiment  = {}
    reviews.each do |review|
      next if review[:rescore_review].nil? || review[:rescore_review].empty?
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
    end

    topics_sentiment = topics_sentiment.map { |k, v| [k, v.reduce(:+) / v.size] }
    people_sentiment = people_sentiment.sort_by { |_, v| v.size }
    people_sentiment = people_sentiment.
      map { |k, v| [k, v.reduce(:+) / v.size, v.size] }.reverse.
      reject { |_, _, c| c < 3}.
      sort_by { |_, v, c| (v * 100).to_f / c }.reverse

    {topics: topics_sentiment, people: people_sentiment}
  end

  def set_stats
    topic_counts = Hash.new(0)
    reviews.each do |review|
      next if review[:rescore_review].nil?
      review[:rescore_review].each do |sentence|
        sentence[:context_tags].keys.each do |tag|
          topic_counts[tag] += 1
        end
      end
    end

    rating_distribution = []
    rounded_ratings = reviews.map {|x| (x[:percentage] / 10 unless x[:percentage].nil?).to_i * 10 }
    (0..100).step(10) do |n|
      rating_distribution << rounded_ratings.count(n)
    end
    {topic_counts: topic_counts, rating_distribution: rating_distribution}
  end

  def self.summarized
    all.reject { |movie| movie.stats.empty? }
  end

  private
    def dup_hash(ary)
     ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select {
     |k,v| v > 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
    end
end
