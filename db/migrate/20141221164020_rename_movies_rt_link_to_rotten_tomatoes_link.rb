class RenameMoviesRtLinkToRottenTomatoesLink < ActiveRecord::Migration
  def change
    rename_column :movies, :rt_link, :rotten_tomatoes_link
  end
end
