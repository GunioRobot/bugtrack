class CreateUserAccounts < ActiveRecord::Migration
  def self.up
    create_table :user_accounts do |t|
      t.integer :user_id, :null => false
      t.integer :role_id, :null => false
      t.integer :account_id, :null => false
    end
    add_index :user_accounts, [:user_id, :role_id, :account_id]  end

  def self.down
    drop_table :user_accounts
  end
end
