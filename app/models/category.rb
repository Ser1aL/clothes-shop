class Category < ActiveRecord::Base
  has_many :item_models
  has_many :banners
  validates_presence_of :name
  TOP_CATEGORIES = { :clothes => 1, :shoes => 2, :accessories => 3, :watches => 4, :sunglasses => 5, :bags => 6 }

  def sub_categories
    item_models.map(&:sub_category).uniq.sort_by(&:name)
  end

  def name
    display_name.blank? ? super : display_name
  end

  def top_category_name
    TOP_CATEGORIES.find{ |_, top_category_id| top_category_id == self.top_category }.try(:[], 0)
  end

  def to_param
    "#{id}-*"
  end

end
