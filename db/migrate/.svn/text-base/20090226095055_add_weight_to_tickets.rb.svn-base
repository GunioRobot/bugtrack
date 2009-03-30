class AddWeightToTickets < ActiveRecord::Migration
  def self.up
    self.execute("Alter table tickets add column weight integer not null default 0")
  end

  def self.down
    self.execute("Alter table tickets drop column weight")
  end

end
