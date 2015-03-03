class AddSlugToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :slug, :string
  end
end
