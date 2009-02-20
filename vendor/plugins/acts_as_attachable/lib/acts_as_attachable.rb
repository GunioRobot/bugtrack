# ActsAsAttachable
module Juixe
  module Acts #:nodoc:
    module Attachable #:nodoc:
      def self.included(base)
        base.extend ClassMethods  
      end

      module ClassMethods
        def acts_as_attachable
          has_many :attachments, :as => :attachable, :dependent => :destroy, :order => 'created_at ASC'
          include Juixe::Acts::Attachable::InstanceMethods
          extend Juixe::Acts::Attachable::SingletonMethods
        end
      end

      module SingletonMethods
        # Helper method to lookup for comments for a given object.
        # This method is equivalent to obj.comments.
        def find_attachments_for(obj)
          attachable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s

          Attachment.find(:all,
            :conditions => ["attachable_id = ? and attachable_type = ?", obj.id, attachable],
            :order => "created_at DESC"
          )
        end

        # Helper class method to lookup comments for
        # the mixin commentable type written by a given user.
        # This method is NOT equivalent to Comment.find_comments_for_user
        def find_attachments_by_user(user)
          attachable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s

          Attachment.find(:all,
            :conditions => ["user_id = ? and attachable_type = ?", user.id, attachable],
            :order => "created_at DESC"
          )
        end
      end

      # This module contains instance methods
      module InstanceMethods
        # Helper method to sort comments by date
        def attachments_ordered_by_submitted
          Attachment.find(:all,
            :conditions => ["attachable_id = ? and attachable_type = ?", id, self.type.name],
            :order => "created_at DESC"
          )
        end

        # Helper method that defaults the submitted time.
        def add_atthacment(attachment)
          attachments << attachment
        end
      end
    end
  end
end
