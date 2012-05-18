class Style < ActiveRecord::Base
  belongs_to :product
  has_many :image_attachments, :as => :association
  has_many :stocks
  has_many :shopping_cart_lines
  has_many :order_lines

  def original_price_extra
    (original_price + original_price * 10 / 100).to_i
  end

  def discount_price_extra
    (discount_price + discount_price * 10 / 100).to_i
  end

  def is_shoes?
    stocks[0].width.to_i.to_s != stocks[0].width && stocks[0].width != 'One Size'
  end
end
