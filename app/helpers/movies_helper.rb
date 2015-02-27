module MoviesHelper

  def comparison_summary(movie_one, movie_two)
    m1 = movie_one
    m2 = movie_two
    winners = {:sentiment => nil, :review_controversy => nil}

    # Aspect sentiment.
    m1.sentiment[:topics].each do |topic|
      if m2.sentiment[:topics][topic[0]] && topic[1] > m2.sentiment[:topics][topic[0]]
        winners[:sentiment] = m1.title
      end
      if m2.sentiment[:topics][topic[0]] && topic[1] < m2.sentiment[:topics][topic[0]]
        winners[:sentiment] = m2.title
      end
    end

    if m2.sentiment[:distribution_stats][:st_dev] && m2.sentiment[:distribution_stats][:st_dev] > m1.sentiment[:distribution_stats][:st_dev]
      winners[:review_controversy] = m2.title
    elsif m2.sentiment[:distribution_stats][:st_dev] && m2.sentiment[:distribution_stats][:st_dev] < m1.sentiment[:distribution_stats][:st_dev]
      winners[:review_controversy] = m1.title
    else
      winners[:review_controversy] = :both
    end

    return winners
  end

end
