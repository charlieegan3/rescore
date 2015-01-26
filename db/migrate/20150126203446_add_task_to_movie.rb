class AddTaskToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :task, :string
  end
end
