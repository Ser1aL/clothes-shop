class CreateOrderLines < ActiveRecord::Migration
  def self.up
    create_table :order_lines do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :quantity
      t.integer :style_id
      t.integer :stock_id

      t.timestamps
    end
  end

  def self.down
    drop_table :order_lines
  end
end
