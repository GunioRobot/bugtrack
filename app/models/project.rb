class Project < ActiveRecord::Base
  permalinked_with :permalink
  belongs_to :account
  has_many :user_projects
  has_many :users, :through=> :user_projects
  has_many :milestones
  has_many :tickets
  has_many :actions, :as => :actionable, :dependent => :destroy, :order => 'created_at ASC'
  acts_as_permalinked

  before_create :make_permalink

  validates_presence_of :name, :message => _("Project name is missing")
  validates_uniqueness_of :name

  validates_presence_of :type_id, :message => _("Project type is missing")
  
  protected
  def make_permalink
    generate_permalink(:value => self.name, :exclude => ["www"])
  end
end
