class Role < ActiveRecord::Base
  permalinked_with :id

  has_many :user_projects
  has_many :user_accounts

  has_many :actions, :as => :actionable, :dependent => :destroy, :order => 'created_at ASC'
end
