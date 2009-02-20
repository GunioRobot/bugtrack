class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.column :project_id, :integer, :null=> false
      t.column :name, :string, :null => false
      t.column :description, :text
      t.column :due_date, :date
      t.timestamps
    end
    add_index :milestones, [:project_id, :created_at]
  end

  def self.down
    drop_table :milestones
  end
end
