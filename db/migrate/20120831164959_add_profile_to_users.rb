class AddProfileToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string :nickname
      t.boolean :gender
      t.string :description
      t.string :avatar
      t.string :province, :limit => 6
      t.string :city, :limit => 6
      t.string :district, :limit => 6
    end
  end
end
