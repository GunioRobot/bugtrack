class Subscribe < ActiveRecord::Base
  permalinked_with :id
  belongs_to :ticket
  belongs_to :user

  has_many :actions, :as => :actionable, :dependent => :destroy, :order => 'created_at ASC'
end
