class AddEmailSenderToTickets < ActiveRecord::Migration
  # email_sender
  # 1 - send
  # 0 - not send
  # change_type
  # 1 - created
  # 2 - updated
  def self.up
    add_column :tickets, :email_sender, :integer
    add_column :tickets, :change_type, :integer
  end

  def self.down
    remove_column :tickets, :email_sender
    remove_column :tickets, :change_type
  end
end
