class CreateSubscribes < ActiveRecord::Migration
  def self.up
    create_table :subscribes do |t|
      t.integer :ticket_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :subscribes, [:ticket_id, :created_at]
    add_index :subscribes, [:user_id, :created_at]
  end

  def self.down
    drop_table :subscribes
  end
end
