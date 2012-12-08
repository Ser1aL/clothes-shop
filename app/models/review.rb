class Review < ActiveRecord::Base
  attr_accessible :body, :email, :verified, :name

  validates_presence_of :email, :body
end
