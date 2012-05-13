class Product < ActiveRecord::Base
  has_many :order_lines
  belongs_to :item_model

  validates :original_price, :numericality => { :greater_than => 0 }
  validates :discount_price, :numericality => { :greater_than => 0 }
  validates :quantity, :numericality => { :greater_than => 0 }
  # validates :item_model, :numericality => { :greater_than => 0 }
  # validates_associated :item_model
end
