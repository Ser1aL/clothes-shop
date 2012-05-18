class Category < ActiveRecord::Base
  has_many :item_models
  validates_presence_of :name

  def sub_categories
    item_models.map(&:sub_category).uniq
  end
end
