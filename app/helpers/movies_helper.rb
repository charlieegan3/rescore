module MoviesHelper
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
