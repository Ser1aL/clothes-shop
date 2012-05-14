class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.decimal :avg_original_price, :precision => 10, :scale => 2
      t.decimal :avg_discount_price, :precision => 10, :scale => 2
      t.integer :total_quantity

      t.integer :item_model_id

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
