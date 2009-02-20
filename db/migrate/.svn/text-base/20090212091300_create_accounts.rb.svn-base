class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.column :permalink, :string, :null => false, :unique => true
      t.integer :user_id, :null => false
      t.string :name, :null => false, :unique=> true
      t.string :time_zone, :null => false
      t.timestamps
    end
    add_index :accounts, [:user_id, :created_at]
  end

  def self.down
    drop_table :accounts
  end
end
