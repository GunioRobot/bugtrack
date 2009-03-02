class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer :project_id, :null => false
      t.string :name, :null => false
      t.text :value, :null => false
      t.timestamps
    end
    add_index :settings, [:project_id, :created_at]
  end

  def self.down
    drop_table :settings
  end
end
