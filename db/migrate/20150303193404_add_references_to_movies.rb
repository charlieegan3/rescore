class AddReferencesToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :references, :text
  end
end
