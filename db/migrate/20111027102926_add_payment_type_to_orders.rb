class AddPaymentTypeToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :payment_type, :enum, :limit => [:bank_payment, :cash_on_delivery, :postal_service]
  end

  def self.down
    remove_column :orders, :payment_type
  end
end
