class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.text :description
      t.references :movie, index: true

      t.timestamps
    end
  end
end
