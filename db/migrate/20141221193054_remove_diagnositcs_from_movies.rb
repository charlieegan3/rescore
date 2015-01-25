class RemoveDiagnositcsFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :diagnostics
  end
end
