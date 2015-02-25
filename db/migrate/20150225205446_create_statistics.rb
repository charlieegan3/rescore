class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.string :identifier
      t.text :value

      t.timestamps
    end
  end
end
