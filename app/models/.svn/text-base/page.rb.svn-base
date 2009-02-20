class Page < ActiveRecord::Base
  permalinked_with :permalink
  
  belongs_to :page
  belongs_to :user

  has_many :actions, :as => :actionable, :dependent => :destroy, :order => 'created_at ASC'
  
  acts_as_commentable
  acts_as_attachable
  acts_as_permalinked

  before_create :make_permalink
  
  protected
  def make_permalink
    generate_permalink(:value => self.name, :exclude => ["www"])
  end
end
