class AddStatsToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :stats, :text
  end
end
