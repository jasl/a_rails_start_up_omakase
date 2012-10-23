class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider, :limit => 20, :null => false
      t.string :uid, :limit => 20, :null => false
      t.string :access_token, :limit => 255, :null => false
      t.integer :expires_at, :null => false
      t.string :refresh_token
      t.references :user

      t.timestamps
    end

    add_index :authorizations, [:provider, :uid], :unique => true
    add_index :authorizations, [:user_id, :provider], :unique => true
    add_index :authorizations, :user_id
  end
end
