class AddCallbackToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :callback, :string
  end
end
