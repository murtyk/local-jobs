class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.float :lat
      t.float :lng

      t.timestamps null: false
    end
    add_index :locations, :name, unique: true
  end
end
