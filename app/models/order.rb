class Order < ActiveRecord::Base
  include ActiveModel::Validations

  #class LinesValidator < ActiveModel::EachValidator
  #  def validate_each(record, attribute, value)
  #    record.errors[attribute] << I18n.t('activerecord.errors.models.order.attributes.order_lines.empty_order_lines') if value.size <= 0
  #  end
  #end
  
  belongs_to :user
  has_many :order_lines

  #validates_inclusion_of :status, :in => [:submitted, :paid, :sent, :delivered]
  #validates_datetime :order_time

  #validates_associated :order_lines
  #validates :order_lines, :lines => true

  def update_total
    update_attribute :total, order_lines.map(&:total).sum
    update_attribute :total, self.total + 15 if delivery_city.present?
  end

  def self.valid_attribute?(attr, value)
    mock = self.new(attr => value)
    unless mock.valid?
      return !mock.errors.has_key?(attr)
    end
    true
  end
end
