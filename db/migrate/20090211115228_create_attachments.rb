class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.column :user_id, :integer
      t.column :attachable_type, :string, :null=> false
      t.column :attachable_id, :integer, :null=> false
      t.column :content_type, :string
      t.column :filename, :string, :limit=> 40
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :description, :text, :null=> true
      t.column :width, :integer
      t.column :height, :integer
      t.timestamps
    end
    add_index :attachments, [:user_id, :created_at]
    add_index :attachments, [:attachable_type, :attachable_id]
  end

  def self.down
    drop_table :attachments
  end
end
