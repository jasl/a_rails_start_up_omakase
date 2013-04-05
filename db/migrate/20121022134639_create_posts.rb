class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.references :user, :null => false
      t.string :state, :limit => 11, :null => false, :default => 'published'
      t.timestamps
    end

    add_index :posts, :user_id
    add_index :posts, :state
  end
end
