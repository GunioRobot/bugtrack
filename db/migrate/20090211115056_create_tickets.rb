class CreateTickets < ActiveRecord::Migration
  def self.up
    #   ticket states
    #   1 - new
    #   2 - open
    #   3- resolved
    #   4 - hold
    #   5 - invalid
    #   6 - work_for_me
    #
    create_table :tickets do |t|
      t.column :permalink, :string, :null => false, :unique => true
      t.column :created_user_id, :integer, :null => false
      t.column :responsible_id, :integer
      t.column :project_id, :integer, :null => false
      t.column :milestone_id, :integer
      t.column :urgency, :integer, :null => false, :default=> 2
      t.column :severity, :integer, :null => false, :default=> 2
      t.column :title, :string, :null => false
      t.column :description, :text
      t.column :state, :integer, :null => false
      t.timestamps
    end
    add_index :tickets, [:created_user_id, :created_at]
    add_index :tickets, [:responsible_id, :created_at]
    add_index :tickets, [:project_id, :created_at]
    add_index :tickets, [:milestone_id, :created_at]
  end

  def self.down
    drop_table :tickets
  end
end
