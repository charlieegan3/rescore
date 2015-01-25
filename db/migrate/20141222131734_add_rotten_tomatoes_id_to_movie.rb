class AddRottenTomatoesIdToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :rotten_tomatoes_id, :string
  end
end
