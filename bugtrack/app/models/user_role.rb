class UserRole < ActiveRecord::Base
  permalinked_with :id
  belongs_to :user
  belongs_to :role

#   has_many :actions, :as => :actionable, :dependent => :destroy, :order => 'created_at ASC'
end
