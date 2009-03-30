class AddColumns2comments < ActiveRecord::Migration
  def self.up
    add_column :comments, :responsible_id, :integer
    add_column :comments, :milestone_id, :integer
    add_column :comments, :urgency, :integer
    add_column :comments, :severity, :integer
    add_column :comments, :state, :integer
    add_column :comments, :before_responsible_id, :integer
    add_column :comments, :before_milestone_id, :integer
    add_column :comments, :before_urgency, :integer
    add_column :comments, :before_severity, :integer
    add_column :comments, :before_state, :integer
  end

  def self.down
    remove_column :comments, :responsible_id
    remove_column :comments, :milestone_id
    remove_column :comments, :urgency
    remove_column :comments, :severity
    remove_column :comments, :state
    remove_column :comments, :before_responsible_id
    remove_column :comments, :before_milestone_id
    remove_column :comments, :before_urgency
    remove_column :comments, :before_severity
    remove_column :comments, :before_state
  end
end
