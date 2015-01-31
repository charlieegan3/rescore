class AddSentimentAndRatingsToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :rating_distribution, :text
    add_column :movies, :sentiment, :text
  end
end
