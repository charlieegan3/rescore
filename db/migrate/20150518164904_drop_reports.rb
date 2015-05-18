class DropReports < ActiveRecord::Migration
  def change
    drop_table :reports
  end
end
