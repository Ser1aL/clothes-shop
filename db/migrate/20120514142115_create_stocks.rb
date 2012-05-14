class CreateStocks < ActiveRecord::Migration
  def self.up
    create_table :stocks do |t|
      t.string :size
      t.string :width
      t.integer :quantity
      t.string :external_stock_id
      t.integer :style_id

      t.timestamps
    end
  end

  def self.down
    drop_table :stocks
  end
end
