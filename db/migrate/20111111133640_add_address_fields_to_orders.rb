class AddAddressFieldsToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :city, :string
    add_column :orders, :address, :string
    add_column :orders, :country, :string
  end

  def self.down
    remove_column :orders, :address
    remove_column :orders, :city
    remove_column :orders, :country
  end
end
