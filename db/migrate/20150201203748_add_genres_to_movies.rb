class AddGenresToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :genres, :text
  end
end
