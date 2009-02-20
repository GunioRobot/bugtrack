class CreateUsers < ActiveRecord::Migration
  def self.up
    # email prefence values
    # 1 - send all ticket changes
    # 2 - send only user's ticket changes
    # 3 - no notification

    create_table "users", :force => true do |t|
      t.column :account_id,                :integer
      t.column :name,                      :string, :limit => 100, :default => '', :null => true
      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :job_title,                 :string
      t.column :activation_code,           :string
      t.column :email_preference,          :integer
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
    end
    add_index :users, [:account_id, :created_at]
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
