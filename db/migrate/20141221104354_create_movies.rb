class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :imdb_link
      t.string :rt_link
      t.string :amazon_link
      t.string :metacritic_link

      t.timestamps
    end
  end
end
