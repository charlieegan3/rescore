module MoviesHelper

  def show_summary(movie)
    summary = {:review_count => "", :topic_counts => "", :topic_sentiments => "", :people_count => ""}
    indicators = {:review_count => false, :topic_counts => false, :topic_sentiments => false, :people_count => false}

    if movie.reviews.size >= Statistic.find_by_identifier('review_count').value[:count] / Movie.count
      summary[:review_count] = "#{movie.title} has an above average review count."
      indicators[:review_count] = true
    else
      summary[:review_count] = "#{movie.title} has a below average review count."
    end

    if movie.related_people.size >= Statistic.find_by_identifier('people_count').value[:count] / Movie.count
      summary[:people_count] = "#{movie.title} has an above average number of cast members."
      indicators[:people_count] = true
    else
      summary[:people_count] = "#{movie.title} has a below average number of cast members."
    end

    if movie.stats[:topic_counts].values.sum >= Statistic.find_by_identifier('topic_counts').value.values.sum / Movie.count
      summary[:topic_counts] = "#{movie.title} has an above average number of topics."
      indicators[:topic_counts] = true
    else
      summary[:topic_counts] = "#{movie.title} has a below average number of topics."
    end

    if movie.sentiment[:topics].values.sum >= Statistic.find_by_identifier('topic_sentiments').value.values.sum / Movie.count
      summary[:topic_sentiments] = "#{movie.title} has an above average overall topic sentiment."
      indicators[:topic_sentiments] = true
    else
      summary[:topic_sentiments] = "#{movie.title} has a below average overall topic sentiment."
    end

    [summary, indicators]
  end

end
