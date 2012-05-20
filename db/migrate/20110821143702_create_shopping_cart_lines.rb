class CreateShoppingCartLines < ActiveRecord::Migration
  def self.up
    create_table :shopping_cart_lines do |t|
      t.integer :product_id
      t.integer :shopping_cart_id
      t.integer :quantity
      t.integer :style_id
      t.integer :stock_id

      t.decimal :price, :precision => 10, :scale => 2
      t.string :currency
      t.timestamps
    end
  end

  def self.down
    drop_table :shopping_cart_lines
  end
end
