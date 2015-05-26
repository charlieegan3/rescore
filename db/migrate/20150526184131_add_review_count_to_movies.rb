class AddReviewCountToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :review_count, :integer
  end
end
