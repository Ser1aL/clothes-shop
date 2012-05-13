class Color < ActiveRecord::Base
  has_many :item_models
  validates_presence_of :name

  def self.distinct_by_brand(brand)
    ItemModel.group(:color_id).find_all_by_brand_id(brand).map(&:color).map {|mechanism| [mechanism.name, mechanism.id]}
  end

end
