class ShoppingCartLine < ActiveRecord::Base
  belongs_to :product
  belongs_to :shopping_cart

  class ProductValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << I18n.t('activerecord.errors.models.shopping_cart_line.attributes.product.cannot_be_nil') if value.class != Product
    end
  end

  validates :product, :product => true
  validates :product_id, :numericality => { :greater_than => 0 }
  validates :quantity, :numericality => { :greater_than => 0 }
  validates :price, :numericality => { :greater_than => 0 }

  def total
    price * quantity
  end

end
