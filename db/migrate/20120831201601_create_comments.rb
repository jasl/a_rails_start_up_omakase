class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :title, :limit => 50, :default => "" 
      t.text :comment, :null => false
      t.references :commentable, :polymorphic => true, :null => false
      t.references :user, :null => false
      t.string :state, :null => false, :default => 'published'

      t.timestamps
    end

    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
    add_index :comments, :user_id
  end

  def self.down
    drop_table :comments
  end
end
