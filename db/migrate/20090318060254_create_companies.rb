class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.integer :user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
