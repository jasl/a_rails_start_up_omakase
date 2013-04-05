class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title, :limit => 50, :default => ""
      t.text :body, :null => false
      t.references :commentable, :polymorphic => true, :null => false
      t.references :user, :null => false
      t.string :state, :limit => 11, :null => false, :default => 'published'

      t.timestamps
    end

    add_index :comments, [:commentable_type, :commentable_id], :name => 'commentable'
    add_index :comments, :user_id
    add_index :comments, :state
  end
end
