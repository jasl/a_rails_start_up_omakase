class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :access_token, :null => false
      t.string :original_name
      t.string :store_name, :null => false
      t.string :store_path
      t.integer :file_size
      t.string :content_type
      # t.string :checksum, :null => false

      t.string :description
      t.string :extra

      t.string :type, :null => false
      t.string :assetable_id, :null => false
      t.string :assetable_type, :null => false

      t.timestamps
    end

    add_index :assets, [:assetable_type, :assetable_id]
    add_index :assets, :access_token, :unique => true
    # add_index :assets, :checksum, :unique => true
  end
end
