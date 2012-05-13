class ChangeDeliveryTypeOrders < ActiveRecord::Migration
  def self.up
    change_column :orders, :delivery_type, :enum, :limit => [:postal_service, :autolux, :intime, :night_express, :pickup, :nova_pochta]
  end

  def self.down
    change_column :orders, :delivery_type, :enum, :limit => [:postal_service, :autolux, :intime, :night_express, :pickup, :nova_postal_service]
  end
end
