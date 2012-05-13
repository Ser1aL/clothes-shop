class Order < ActiveRecord::Base
  include ActiveModel::Validations

  class LinesValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << I18n.t('activerecord.errors.models.order.attributes.order_lines.empty_order_lines') if value.size <= 0
    end
  end
  
  belongs_to :user
  has_many :order_lines

  validates_presence_of :order_time, :status, :delivery_type, :address, :city
  validates_inclusion_of :status, :in => [:submitted, :paid, :sent]
  validates_inclusion_of :delivery_type, :in => [:postal_service, :autolux, :intime, :night_express, :pickup, :nova_pochta]
  validates_inclusion_of :payment_type, :in => [:postal_service, :cash_on_delivery, :bank_payment]
  validates_datetime :order_time

  validates_associated :order_lines
  validates :order_lines, :lines => true

  def update_total
    update_attribute :total, order_lines.map(&:total).sum
  end

  def self.valid_attribute?(attr, value)
    mock = self.new(attr => value)
    unless mock.valid?
      return !mock.errors.has_key?(attr)
    end
    true
  end
end
