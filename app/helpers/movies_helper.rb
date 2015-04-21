module MoviesHelper

  def facts(movie)
    global_people_count = Statistic.find_by_identifier('people_count').value[:count]
    sentiment_variation = Statistic.find_by_identifier('sentiment_variation').value[:variation]
    var = (movie.sentiment[:distribution_stats][:st_dev])
    [].tap do |facts|
      if var >= sentiment_variation
        facts << "#{movie.title} has high rating variation."
      else
        facts << "#{movie.title} has low rating variation."
      end

      if (movie.related_people[:cast].size + movie.related_people[:directors].size) >= (global_people_count / Movie.count)
        facts << "Has a larger than average cast."
      else
        facts << "Has a smaller than average cast."
      end

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
