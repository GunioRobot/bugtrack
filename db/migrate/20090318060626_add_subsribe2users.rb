class AddSubsribe2users < ActiveRecord::Migration
  def self.up
    add_column :users, :subscribe, :integer, :default => 1, :null=> false
  end

  def self.down
    remove_column :users, :subscribe
  end
end
