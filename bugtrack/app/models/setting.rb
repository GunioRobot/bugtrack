class Setting < ActiveRecord::Base
  permalinked_with :id
  belongs_to :project

  has_many :actions, :as => :actionable, :dependent => :destroy, :order => 'created_at ASC'
end
