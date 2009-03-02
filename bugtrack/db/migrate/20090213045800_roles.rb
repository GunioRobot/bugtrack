class Roles < ActiveRecord::Migration
  def self.up
    self.execute("Insert into roles(name) values('account.admin')")
    self.execute("Insert into roles(name) values('account.member')")
    self.execute("Insert into roles(name) values('project.admin')")
    self.execute("Insert into roles(name) values('project.member')")
  end

  def self.down
    self.execute("Delete From roles Where name = 'account.admin' Or 'account.member'")
  end
end
