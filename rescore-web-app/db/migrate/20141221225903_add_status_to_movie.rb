class AddStatusToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :status, :string
  end
end
