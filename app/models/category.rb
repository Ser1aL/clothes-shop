class Category < ActiveRecord::Base
  has_many :item_models
  has_many :sub_categories
  validates_presence_of :name
end
