class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :permalink, :null => false, :unique => true
      t.integer :user_id, :null => false
      t.integer :project_id, :null => false
      t.integer :parent_page_id, :null => false
      t.integer :height, :null=> false, :default => 0
      t.string :title, :null => false
      t.text :body, :null => false
      t.timestamps
    end
    add_index :pages, :project_id
  end

  def self.down
    drop_table :pages
  end
end
