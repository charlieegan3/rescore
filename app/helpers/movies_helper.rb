module MoviesHelper

  def show_summary(movie)
    summary = {review_count: "", topic_counts: "", topic_sentiments: "", people_count: ""}
    indicators = {review_count: false, topic_counts: false, topic_sentiments: false, people_count: false}
    facts = []

    if movie.stats[:review_count] >= Statistic.find_by_identifier('review_count').value[:count] / Movie.count
      summary[:review_count] = "Has an above average review count."
      indicators[:review_count] = true
    else
      summary[:review_count] = "Has a below average review count."
    end

    if movie.related_people.size >= Statistic.find_by_identifier('people_count').value[:count] / Movie.count
      summary[:people_count] = "Has an above average number of cast members."
      indicators[:people_count] = true
    else
      summary[:people_count] = "Has a below average number of cast members."
    end

    if movie.stats[:topic_counts].values.sum >= Statistic.find_by_identifier('topic_counts').value.values.sum / Movie.count
      summary[:topic_counts] = "Has an above average number of topics."
      indicators[:topic_counts] = true
    else
      summary[:topic_counts] = "Has a below average number of topics."
    end

    if movie.sentiment[:topics].values.sum >= Statistic.find_by_identifier('topic_sentiments').value.values.sum / Movie.count
      summary[:topic_sentiments] = "Has an above average overall topic sentiment."
      indicators[:topic_sentiments] = true
    else
      summary[:topic_sentiments] = "Has a below average overall topic sentiment."
    end

    facts << "People seem to talk about #{movie.stats[:topic_counts].max_by{|k,v| v}[0].to_s} the most."

    sentiment_variation = Statistic.find_by_identifier('sentiment_variation').value[:variation]
    facts << "#{movie.title} has a high variation of ratings." if (movie.sentiment[:distribution_stats][:st_dev] * 100).to_i >= sentiment_variation
    facts << "#{movie.title} has a low variation of ratings." if (movie.sentiment[:distribution_stats][:st_dev] * 100).to_i < sentiment_variation

    facts << "#{movie.sentiment[:topics].max_by{|k,v| v}[0].to_s.capitalize} is the most favoured aspect of the movie."

    [summary, indicators, facts]
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
