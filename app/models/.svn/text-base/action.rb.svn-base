class Action < ActiveRecord::Base
  permalinked_with :permalink
  acts_as_permalinked

#   before_create :make_permalink
  
  belongs_to :actionable, :polymorphic => true
  belongs_to :user
  belongs_to :project

#   protected
#   def make_permalink
#     generate_permalink(:value => self.name, :exclude => ["www"])
#   end
end
