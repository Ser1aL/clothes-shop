class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :style
  belongs_to :stock

  def total
    price * quantity
  end
end
