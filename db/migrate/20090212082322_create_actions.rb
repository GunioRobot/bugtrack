class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions do |t|
      t.string :actionable_type, :null => false
      t.integer :actionable_id, :null => false
      t.integer :user_id, :null => false
      t.integer :project_id, :null=> false
      t.text :what_did
      t.timestamps
    end
    add_index :actions, [:actionable_type, :actionable_id]
    add_index :actions, [:user_id, :created_at]
  end

  def self.down
    drop_table :actions
  end
end
