class Stock < ActiveRecord::Base
  belongs_to :style
  has_many :order_lines
  has_many :shopping_cart_lines
end
