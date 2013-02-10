class ShoppingCartLine < ActiveRecord::Base
  belongs_to :product
  belongs_to :shopping_cart
  belongs_to :style
  belongs_to :stock

  def total
    price * quantity
  end

end
