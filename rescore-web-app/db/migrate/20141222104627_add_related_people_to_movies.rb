class AddRelatedPeopleToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :related_people, :text
  end
end
