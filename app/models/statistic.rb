class Statistic < ActiveRecord::Base
  validates_uniqueness_of :identifier
  serialize :value, Hash

  def self.get_stat(identifier)
    Statistic.refresh if !Statistic.exists?(:identifier => identifier)
    Statistic.find_by_identifier(identifier)
  end

  def self.refresh
    delete_all

    create(identifier: 'review_count', value: {count: Movie.review_count})
    create(identifier: 'topic_counts', value: Movie.topic_counts)
    create(identifier: 'topic_sentiments', value: Movie.topic_sentiments)
    create(identifier: 'people_count', value: {count: Movie.people_count})
    create(identifier: 'sentiment_variation', value: {variation: Movie.variation})
  end
end
