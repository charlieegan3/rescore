require_relative '../../config/environment'

task :refresh do
  Statistic.delete_all

  Statistic.create(identifier: 'review_count', value: {count: Movie.review_count})
  Statistic.create(identifier: 'topic_counts', value: Movie.topic_counts)
  Statistic.create(identifier: 'topic_sentiments', value: Movie.topic_sentiments)
  Statistic.create(identifier: 'people_count', value: {count: Movie.people_count})


end
