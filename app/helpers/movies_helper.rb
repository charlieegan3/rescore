module MoviesHelper

  def comparison_summary(movie_one, movie_two)
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

end
