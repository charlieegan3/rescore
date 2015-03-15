class AddCategoryToReports < ActiveRecord::Migration
  def change
    add_column :reports, :category, :string
  end
end
