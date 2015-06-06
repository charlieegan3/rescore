class AddRottenTomatoesIdMoviesIndex < ActiveRecord::Migration
  def change
    add_index :movies, :rotten_tomatoes_id, unique: true
  end
end
