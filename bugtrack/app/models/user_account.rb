class UserAccount < ActiveRecord::Base
  permalinked_with :id
  belongs_to :role
  belongs_to :user
end
