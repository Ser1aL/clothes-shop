class SubCategory < ActiveRecord::Base
  has_many :item_models
  belongs_to :category
  validates_presence_of :name

end
