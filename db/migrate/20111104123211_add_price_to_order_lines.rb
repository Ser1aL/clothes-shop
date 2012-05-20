class AddPriceToOrderLines < ActiveRecord::Migration
  def self.up
    add_column :order_lines, :price, :decimal, :precision => 10, :scale => 2
    add_column :order_lines, :currency, :string
  end

  def self.down
    remove_column :order_lines, :price
    remove_column :order_lines, :currency
  end
end
