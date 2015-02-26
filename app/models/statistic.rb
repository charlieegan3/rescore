class Statistic < ActiveRecord::Base
  validates_uniqueness_of :identifier
  serialize :value, Hash

  def self.refresh
    delete_all

    create(identifier: 'review_count', value: {count: Movie.review_count})
    create(identifier: 'topic_counts', value: Movie.topic_counts)
    create(identifier: 'topic_sentiments', value: Movie.topic_sentiments)
    create(identifier: 'people_count', value: {count: Movie.people_count})
  end
end
