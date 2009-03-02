class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :commentable_type, :string, :null => false
      t.column :commentable_id, :integer, :null => false
      t.column :user_id, :integer, :null=> false
      t.column :account_id, :integer, :null=> false
      t.column :project_id, :integer, :null=> false
      t.column :ticket_id, :integer, :null=> false
      t.column :title, :string, :null=> false
      t.column :comment, :text, :null=> false
      t.timestamps
    end
    add_index :comments, [:commentable_type, :commentable_id, :created_at], :name => "comments_commentable_idx"
    add_index :comments, [:user_id, :created_at]
    add_index :comments, [:ticket_id, :created_at]
    add_index :comments, [:project_id, :created_at]
  end

  def self.down
    drop_table :comments
  end
end
