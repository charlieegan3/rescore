module ApplicationHelper
  def comparison_summary(movie_one, movie_two)
    m1 = movie_one
    m2 = movie_two
    summary = {:aspect_sentiment => "", :aspect_focus => "", :review_range => "", :review_variation => ""}
    winners = {:aspect_sentiment => nil, :aspect_focus => nil, :review_range => nil, :review_variation => nil}

    # Aspect sentiment.
    m1.sentiment[:topics].each_with_index do |topic, i|
      summary[:aspect_sentiment] += " People seem to like #{topic[0].to_s} more in #{m2.title}."; winners[:aspect_sentiment] = m2.title if m2.sentiment[:topics][i][1] && topic[1] > m2.sentiment[:topics][i][1]
      summary[:aspect_sentiment] += " People seem to like #{topic[0].to_s} more in #{m1.title}."; winners[:aspect_sentiment] = m1.title if m2.sentiment[:topics][i][1] && topic[1] < m2.sentiment[:topics][i][1]
    end

    # Aspect discussion focus.
    m1.stats[:topic_counts].each do |topic|
      summary[:aspect_focus] += " People seem to talk more about #{topic[0].to_s} than in #{m2.title}."; winners[:aspect_focus] = m2.title if m2.stats[:topic_counts][topic[0]][1] && topic[1] > m2.stats[:topic_counts][topic[0]][1]
      summary[:aspect_focus] += " People seem to talk more about #{topic[0].to_s} than in #{m1.title}."; winners[:aspect_focus] = m1.title if m2.stats[:topic_counts][topic[0]][1] && topic[1] < m2.stats[:topic_counts][topic[0]][1]
    end

    # Review Sentiment Distribution.
    summary[:review_range] += " #{m2.title} has a higher range of review ratings."; winners[:review_range] = m2.title if m2.sentiment[:distribution_stats][0] && m2.sentiment[:distribution_stats][0] > m1.sentiment[:distribution_stats][0]
    summary[:review_range] += " #{m1.title} has a higher range of review ratings."; winners[:review_range] = m1.title if m2.sentiment[:distribution_stats][0] && m2.sentiment[:distribution_stats][0] < m1.sentiment[:distribution_stats][0]
    summary[:review_variation] += " #{m2.title} has a higher variation of review ratings."; winners[:review_variation] = m2.title if m2.sentiment[:distribution_stats][1] && m2.sentiment[:distribution_stats][1] > m1.sentiment[:distribution_stats][1]
    summary[:review_variation] += " #{m1.title} has a higher variation of review ratings."; winners[:review_variation] = m1.title if m2.sentiment[:distribution_stats][1] && m2.sentiment[:distribution_stats][1] < m1.sentiment[:distribution_stats][1]

    return [summary, winners]
  end
end
