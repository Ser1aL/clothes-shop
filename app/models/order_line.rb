class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates_presence_of :product_id, :quantity, :price
  validates :quantity, :numericality => { :greater_than => 0 }
  validates :product_id, :numericality => { :greater_than => 0 }
  validates :price, :numericality => { :greater_than => 0 }

  def total
    price * quantity
  end
end
