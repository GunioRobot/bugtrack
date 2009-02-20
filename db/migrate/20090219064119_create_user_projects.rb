class CreateUserProjects < ActiveRecord::Migration
  def self.up
    create_table :user_projects do |t|
      t.integer :user_id, :null => false
      t.integer :role_id, :null => false
      t.integer :project_id, :null => false
    end
    add_index :user_projects, [:user_id, :role_id, :project_id]
  end

  def self.down
    drop_table :user_projects
  end
end
