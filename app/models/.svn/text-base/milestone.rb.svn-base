require 'date_validation'
class Milestone < ActiveRecord::Base
  permalinked_with :id
  belongs_to :project
  has_many :tickets
#   has_many :open_tickets, 
#            :class_name => "Ticket",
#            :foreign_key => "ticket_id",
#            :condition=> ["state = ?", Ticket::STATE_RESOLVED]

  has_many :actions, :as => :actionable, :dependent => :destroy, :order => 'created_at ASC'

  validates_presence_of :description
  validates_uniqueness_of :name, :scope=> :project_id
  validates_dates :due_date
  validates_presence_of :name
end
