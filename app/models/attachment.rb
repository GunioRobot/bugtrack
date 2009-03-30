class Attachment < ActiveRecord::Base
  permalinked_with :id
  file_column :image,
              :store_dir => "public/images/attachments",
              :magick => {:versions => {
                  :thumb => {:crop => "1:1",  :size => "86x87!", :name => "peq"},
                  :normal => {:crop => "1:1", :size => "289x258!", :name=>"med"}
                }
              }


  belongs_to :attachable, :polymorphic => true
  belongs_to :ticket

  has_many :actions, :as => :actionable, :dependent => :destroy, :order => 'created_at ASC'

#   def swf_uploaded_data=(data)
#     return nil if data.nil? || data.size == 0 
#     size = data.size.to_i
#     self.content_type = 'image/jpeg'
#     self.filename     = data.original_filename if respond_to?(:filename)
#     self.size = size
#     full_filename
#     self.uploaded_data = data
#   end 
#   
#   def full_filename(thumbnail = nil)
#     file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix]
#     case self.thumbnail
#     when "thumb"
#       File.join(RAILS_ROOT, file_system_path, 'preview', thumbnail_name_for(thumbnail, self.parent_id))
#     when "medium"
#       File.join(RAILS_ROOT, file_system_path, 'midimgs', thumbnail_name_for(thumbnail, self.parent_id))
#     else
#       File.join(RAILS_ROOT, file_system_path, 'largeimgs', thumbnail_name_for(thumbnail, self.id))
#     end
#   end
# 
#   def thumbnail_name_for(thumbnail = nil, asset = nil)
#     extension = filename.scan(/\.\w+$/)
#     return "#{asset}#{extension}"
#   end
#   
#   
#   def self.find_attachments_by_user(user)
#     find(:all,
#       :conditions => ["user_id = ?", user.id],
#       :order => "created_at DESC"
#     )
#   end
# 
#   def self.find_attachments_by_ticket(ticket)
#     find(:all,
#       :conditions => ["ticket_id = ?", ticket.id],
#       :order => "created_at DESC"
#     )
#   end
#   
#   # Helper class method to look up all comments for 
#   # commentable class name and commentable id.
#   def self.find_attachments_for_attachable(attachable_str, attachable_id)
#     find(:all,
#       :conditions => ["attachable_type = ? and attachable_id = ?", attachable_str, attachable_id],
#       :order => "created_at DESC"
#     )
#   end
# 
#   # Helper class method to look up a commentable object
#   # given the commentable class name and id 
#   def self.find_attachable(attachable_str, attachable_id)
#     attachable_str.constantize.find(attachable_id)
#   end
end
