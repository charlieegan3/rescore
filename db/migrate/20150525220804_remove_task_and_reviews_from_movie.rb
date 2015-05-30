class RemoveTaskAndReviewsFromMovie < ActiveRecord::Migration
  def change
    remove_column :movies, :task
    remove_column :movies, :reviews
  end
end
