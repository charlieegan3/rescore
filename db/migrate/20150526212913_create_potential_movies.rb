class CreatePotentialMovies < ActiveRecord::Migration
  def change
    create_table :potential_movies do |t|
      t.string :query
      t.string :rotten_tomatoes_id

      t.timestamps
    end
  end
end
