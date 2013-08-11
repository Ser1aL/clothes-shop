class SubCategory < ActiveRecord::Base
  has_many :item_models
  belongs_to :category
  validates_presence_of :name

  def name
    display_name.blank? ? super : display_name
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

end
