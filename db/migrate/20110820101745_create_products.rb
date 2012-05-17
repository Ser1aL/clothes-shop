class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.integer :total_quantity

      t.integer :item_model_id

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
