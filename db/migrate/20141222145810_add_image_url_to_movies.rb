class AddImageUrlToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :image_url, :string
  end
end
