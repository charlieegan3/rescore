module MoviesHelper
  def topic_counts(movie)
    topic_count_sum = Statistic.find_by_identifier('topic_counts').value.values.sum
    if movie.stats[:topic_counts].values.sum >= topic_count_sum / Movie.count
      return ["Has an above average amount of overall aspect discussion.", true]
    end
    ["Has a below average amount of overall aspect discussion.", false]
  end

  def topic_sentiments(movie)
    topic_sentiments_sum = Statistic.find_by_identifier('topic_sentiments').value.values.sum
    if movie.sentiment[:topics].values.sum >= topic_sentiments_sum / Movie.count
      return ["Has an above average overall aspect sentiment.", true]
    end
    ["Has a below average overall aspect sentiment.", false]
  end

  def facts(movie)
    global_people_count = Statistic.find_by_identifier('people_count').value[:count]
    sentiment_variation = Statistic.find_by_identifier('sentiment_variation').value[:variation]
    var = (movie.sentiment[:distribution_stats][:st_dev])
    [].tap do |facts|
      if var >= sentiment_variation
        facts << "#{movie.title} has a high variation of ratings."
      else
        facts << "#{movie.title} has a low variation of ratings."
      end

      if movie.related_people.size >= global_people_count / Movie.count
        facts << "Has an above average number of cast members."
      end
      facts << "Has a below average number of cast members."

      facts << "#{movie.sentiment[:topics].max_by{|k,v| v}[0].to_s.capitalize} is the most favoured aspect of the movie."
      facts << "People seem to talk about #{movie.stats[:topic_counts].max_by{|k,v| v}[0].to_s} the most."
    end
  end

  def comparison_summary(movie_1, movie_2)
    winners = {overall_sentiment: :both, review_controversy: :both}

    movie_1.sentiment[:topics].each do |topic|
      if movie_2.sentiment[:topics][topic[0]] && topic[1] > movie_2.sentiment[:topics][topic[0]]
        winners[:overall_sentiment] = movie_1.title
      elsif movie_2.sentiment[:topics][topic[0]] && topic[1] < movie_2.sentiment[:topics][topic[0]]
        winners[:overall_sentiment] = movie_2.title
      end
    end

    if movie_2.sentiment[:distribution_stats][:st_dev] > movie_1.sentiment[:distribution_stats][:st_dev]
      winners[:review_controversy] = movie_2.title
    elsif movie_2.sentiment[:distribution_stats][:st_dev] < movie_1.sentiment[:distribution_stats][:st_dev]
      winners[:review_controversy] = movie_1.title
    end

    winners
  end
end
