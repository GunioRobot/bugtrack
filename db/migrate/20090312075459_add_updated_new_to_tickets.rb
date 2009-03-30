class AddUpdatedNewToTickets < ActiveRecord::Migration
  def self.up
    remove_column :tickets, :change_type
    add_column :tickets, :updated, :integer, :null=> false, :default => 0
    add_column :tickets, :new, :integer, :null=> false, :default => 1
  end

  def self.down
    add_column :tickets, :change_type, :integer
    remove_column :tickets, :updated
    remove_column :tickets, :new
  end
end
