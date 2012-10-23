class AddProfileToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string :nickname
      t.string :name
      t.string :phone
      t.integer :age
      t.references :location
      t.boolean :gender
    end
  end
end
