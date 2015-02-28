class AddCompleteFieldToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :complete, :boolean
  end
end
