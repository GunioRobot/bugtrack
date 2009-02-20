class Attachment < ActiveRecord::Base
  permalinked_with :id

  belongs_to :attachable, :polymorphic => true
  belongs_to :ticket

  has_many :actions, :as => :actionable, :dependent => :destroy, :order => 'created_at ASC'
  
  def self.find_attachments_by_user(user)
    find(:all,
      :conditions => ["user_id = ?", user.id],
      :order => "created_at DESC"
    )
  end

  def self.find_attachments_by_ticket(ticket)
    find(:all,
      :conditions => ["ticket_id = ?", ticket.id],
      :order => "created_at DESC"
    )
  end
  
  # Helper class method to look up all comments for 
  # commentable class name and commentable id.
  def self.find_attachments_for_attachable(attachable_str, attachable_id)
    find(:all,
      :conditions => ["attachable_type = ? and attachable_id = ?", attachable_str, attachable_id],
      :order => "created_at DESC"
    )
  end

  # Helper class method to look up a commentable object
  # given the commentable class name and id 
  def self.find_attachable(attachable_str, attachable_id)
    attachable_str.constantize.find(attachable_id)
  end
end
