class Product < ActiveRecord::Base
  has_many :order_lines, dependent: :destroy
  belongs_to :item_model, :dependent => :destroy
  has_many :styles, :dependent => :destroy

  #validates :avg_original_price, :numericality => { :greater_than => 0 }
  #validates :avg_discount_price, :numericality => { :greater_than => 0 }
  #validates :total_quantity, :numericality => { :greater_than => 0 }
  # validates :item_model, :numericality => { :greater_than => 0 }
  # validates_associated :item_model
end
