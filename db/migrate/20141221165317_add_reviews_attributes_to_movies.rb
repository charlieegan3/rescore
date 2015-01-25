class AddReviewsAttributesToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :reviews, :text
    add_column :movies, :diagnostics, :text
  end
end
