class AddAddressFieldsToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :city, :string
    add_column :orders, :address, :string
  end

  def self.down
    remove_column :orders, :address
    remove_column :orders, :city
  end
end
