class Category < ActiveRecord::Base
  has_many :item_models
  has_many :banners
  validates_presence_of :name

  def sub_categories
    item_models.map(&:sub_category).uniq.sort_by(&:name)
  end

  def name
    display_name.blank? ? super : display_name
  end

end
