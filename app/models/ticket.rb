class Ticket < ActiveRecord::Base
  permalinked_with :permalink
#   acts_as_commentable
#   acts_as_attachable
  acts_as_permalinked

  has_many :actions, :as => :actionable
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
  before_create :make_permalink

  has_many :attachments, :as => :attachable
  belongs_to :milestone
  belongs_to :projects
# belongs_to :resp_user,
#             :class_name => "User",
#             :foreign_key => "user_id"
# 
# belongs_to :created_user,
#             :class_name => "User",
#             :foreign_key => "create_user_id"

  has_many :attachments
  has_many :comments

  STATE_NEW = 1
  STATE_OPEN = 2
  STATE_RESOLVED = 3
  STATE_HOLD = 4
  STATE_INVALID = 5
  STATE_WORK_FOR_ME = 6

  HIGH_PRIORITY = 1
  LOW_PRIORITY = 2
  MEDIUM_PRIORITY = 3

  validates_presence_of :description
  validates_presence_of :title
  validates_length_of :title, :within => 2..64
  validates_presence_of :priority
  validates_presence_of :state
  validates_uniqueness_of :title

  protected
  def make_permalink
    generate_permalink(:value => self.title, :exclude => ["www"])
  end
end
