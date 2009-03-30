class Company < ActiveRecord::Base
  permalinked_with :id
  has_many :users
end
