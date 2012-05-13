class SubCategory < ActiveRecord::Base
  has_many :item_models
  validates_presence_of :name

end
