module MoviesHelper

  def comparison_summary(movie_one, movie_two)
    m1 = movie_one
    m2 = movie_two
    winners = {:sentiment => :both, :review_controversy => :both}

    # Aspect sentiment.
    m1.sentiment[:topics].each do |topic|
      if m2.sentiment[:topics][topic[0]] && topic[1] > m2.sentiment[:topics][topic[0]]
        winners[:sentiment] = m1.title
      elsif m2.sentiment[:topics][topic[0]] && topic[1] < m2.sentiment[:topics][topic[0]]
        winners[:sentiment] = m2.title
      end
    end

    if m2.sentiment[:distribution_stats][:st_dev] > m1.sentiment[:distribution_stats][:st_dev]
      winners[:review_controversy] = m2.title
    elsif m2.sentiment[:distribution_stats][:st_dev] < m1.sentiment[:distribution_stats][:st_dev]
      winners[:review_controversy] = m1.title
    end

    return winners
  end

end
