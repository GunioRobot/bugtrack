class CreateRoles < ActiveRecord::Migration
  def self.up
    # user roles
    # 1 - account administrator
    # 2 - member
    create_table :roles do |t|
      t.string :name, :null => false
    end
  end

  def self.down
    drop_table :roles
  end
end
