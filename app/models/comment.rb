class Comment < ActiveRecord::Base
  belongs_to :association, :polymorphic => true
  belongs_to :user

  validates :body, :length => { :minimum => 2, :maximum => 2000 }
end
