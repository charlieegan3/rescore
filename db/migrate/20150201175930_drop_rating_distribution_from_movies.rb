class DropRatingDistributionFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :rating_distribution
  end
end
