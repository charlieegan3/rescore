class AddPageDepthToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :page_depth, :integer
  end
end
