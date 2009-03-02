class Account < ActiveRecord::Base
  permalinked_with :permalink
  acts_as_permalinked

  has_many :projects
  has_many :users, :through=> :user_accounts
  has_many :actions, :as => :actionable, :dependent => :destroy, :order => 'created_at ASC'
  
  before_create :make_permalink

  validates_presence_of :name, :message => _("Account name is missing")
  validates_uniqueness_of :name
  validates_presence_of :time_zone, :message => _("Specify your time zone")
  #validate :valid_time_zone?
  

  protected
  def make_permalink
    generate_permalink(:value => self.name, :exclude => ["www"])
  end
  private
  def valid_time_zone?
    unless TzinfoTimezone[name]
      errors.add(:time_zone, _("Your time zone is incorrect"))
    end
  end
end
