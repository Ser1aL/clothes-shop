class Style < ActiveRecord::Base
  belongs_to :product
  has_many :image_attachments, :as => :association
  has_many :stocks
  has_many :shopping_cart_lines
  has_many :order_lines

  def original_price_extra
    discount_price + discount_price * 10 / 100
  end

  def discount_price_extra
    discount_price + discount_price * 10 / 100
  end
end
