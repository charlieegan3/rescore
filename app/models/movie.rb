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
      GoogleAjax::Search.web(title + " site:www.metacritic.com/movie/ "+ year.to_s)[:results][0][:unescaped_url])
    update_attribute(:amazon_link,
      GoogleAjax::Search.web(title + " site:www.amazon.com dvd reviews " + year.to_s)[:results][0][:unescaped_url])
    update_attribute(:imdb_link,
      GoogleAjax::Search.web(title + " site:www.imdb.com/title/ " + year.to_s)[:results][0][:unescaped_url])
    update_attribute(:rotten_tomatoes_link,
      GoogleAjax::Search.web(title + " site:www.rottentomatoes.com/m/ " + year.to_s)[:results][0][:unescaped_url])
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
    movie = bf.movies.search_by_id(rotten_tomatoes_id)
    cast = movie.full_cast.map { |person|
      {name: person.name, characters: person.characters}
    }
    directors = movie.directors
    update_attribute(:related_people, {cast: cast, directors: directors})
  end

  def build_summary
    summary = []
    sentiment_analyzer = Sentiment::SentimentAnalyzer.new
    reviews.each_with_index do |review, index|
      update_attribute(:status, "#{(index.to_f/reviews.size).round(2) * 100}%") if index % 50 == 0
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
    topics_sentiment  = {plot: [], dialog: [], cast: [], sound: [], vision: [], editing: []}
    people_sentiment  = {}
    average_sentiment = []
    sentiment_averages = [] #this is review level
    reviews.each do |review|
      next if review[:rescore_review].nil? || review[:rescore_review].empty?
      sentiment_average = 0
      review[:rescore_review].each do |sentence|
        average_sentiment << sentence[:sentiment][:average]
        sentiment_average += sentence[:sentiment][:average]
        sentence[:context_tags].keys.each do |tag|
          topics_sentiment[tag] << sentence[:sentiment][:average] * sentence[:context_tags][tag]
        end
        sentence[:people_tags].each do |tag|
          people_sentiment[tag] = [] if people_sentiment[tag].nil?
          people_sentiment[tag] << sentence[:sentiment][:average]
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
    location_sentiment = reviews.map {|x| [x[:location], x[:rescore_review].map {|x| x[:sentiment][:average]}.mean]}
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
    topic_counts = {plot: 0, dialog: 0, cast: 0, sound: 0, vision: 0, editing: 0}
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

  def comparison_summary(movie_one, movie_two)
    m1 = movie_one
    m2 = movie_two
    summary = {:aspect_sentiment => [], :aspect_focus => [], :review_range => [], :review_variation => []}
    winners = {:aspect_sentiment => nil, :aspect_focus => nil, :review_range => nil, :review_variation => nil}

    # Aspect sentiment.
    m1.sentiment[:topics].each_with_index do |topic, i|
      if m2.sentiment[:topics][i][1] && topic[1] > m2.sentiment[:topics][i][1]
        summary[:aspect_sentiment] << " People seem to like #{topic[0].to_s} more in #{m1.title}."
        winners[:aspect_sentiment] = m1.title
      end
      if m2.sentiment[:topics][i][1] && topic[1] < m2.sentiment[:topics][i][1]
        summary[:aspect_sentiment] << " People seem to like #{topic[0].to_s} more in #{m2.title}."
        winners[:aspect_sentiment] = m2.title 
      end
    end

    # Aspect discussion focus.
    m1.stats[:topic_counts].each do |topic|
      if m2.stats[:topic_counts][topic[0]][1] && topic[1] > m2.stats[:topic_counts][topic[0]][1]
        summary[:aspect_focus] << " People seem to talk more about #{topic[0].to_s} in #{m2.title} than in #{m1.title}."
        winners[:aspect_focus] = m1.title
      end
      if m2.stats[:topic_counts][topic[0]][1] && topic[1] < m2.stats[:topic_counts][topic[0]][1]
        summary[:aspect_focus] << " People seem to talk more about #{topic[0].to_s} in #{m1.title} than in #{m2.title}."
        winners[:aspect_focus] = m2.title
      end
    end

    # Review Sentiment distribution and variation.
    if m2.sentiment[:distribution_stats][0] && m2.sentiment[:distribution_stats][0] > m1.sentiment[:distribution_stats][0]
      summary[:review_range] << " #{m2.title} has a higher range of review ratings."
      winners[:review_range] = m2.title
    end
    if m2.sentiment[:distribution_stats][0] && m2.sentiment[:distribution_stats][0] < m1.sentiment[:distribution_stats][0]
      summary[:review_range] << " #{m1.title} has a higher range of review ratings."
      winners[:review_range] = m1.title
    end

    if m2.sentiment[:distribution_stats][1] && m2.sentiment[:distribution_stats][1] > m1.sentiment[:distribution_stats][1]
      summary[:review_variation] << " #{m2.title} has a higher variation of review ratings."
      winners[:review_variation] = m2.title
    end
    if m2.sentiment[:distribution_stats][1] && m2.sentiment[:distribution_stats][1] < m1.sentiment[:distribution_stats][1]
      summary[:review_variation] << " #{m1.title} has a higher variation of review ratings."
      winners[:review_variation] = m1.title
    end

    return [summary, winners]
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
