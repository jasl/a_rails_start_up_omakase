class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :province, :null => false
      t.string :city, :null => false
      t.string :district
    end

    add_index :locations, :province
    add_index :locations, [:province, :city]
    add_index :locations, [:province, :city, :district], :unique => true
  end
end
