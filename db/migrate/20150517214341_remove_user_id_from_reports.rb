class RemoveUserIdFromReports < ActiveRecord::Migration
  def change
    remove_column :reports, :user_id
  end
end
