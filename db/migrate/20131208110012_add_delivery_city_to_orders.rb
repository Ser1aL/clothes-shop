class AddDeliveryCityToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_city, :string
  end
end
