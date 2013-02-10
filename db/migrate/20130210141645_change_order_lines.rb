class ChangeOrderLines < ActiveRecord::Migration
  def up
    add_column :order_lines, :stock_size, :string
    add_column :shopping_cart_lines, :stock_size, :string
    remove_column :order_lines, :stock_id
    remove_column :shopping_cart_lines, :stock_id
  end

  def down
    remove_column :order_lines, :stock_size
    remove_column :shopping_cart_lines, :stock_size, :string
    add_column :order_lines, :stock_id, :integer
    add_column :shopping_cart_lines, :stock_id, :integer
  end
end
