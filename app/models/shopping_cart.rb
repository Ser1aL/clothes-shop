class ShoppingCart < ActiveRecord::Base
  has_many :shopping_cart_lines, :dependent => :restrict
  belongs_to :user

  class UserValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << I18n.t('activerecord.errors.models.shopping_cart_line.attributes.product.cannot_be_nil') if value.class != User
    end
  end
  validates_inclusion_of :status, :in => [:open, :closed]

  def total
    shopping_cart_lines.map(&:total).sum rescue '0'
  end
  
  def close
    update_attribute :status, 'closed'
  end
end
