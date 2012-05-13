class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.decimal :original_price, :precision => 10, :scale => 2
      t.decimal :discount_price, :precision => 10, :scale => 2
      t.integer :quantity

      t.integer :item_model_id

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
