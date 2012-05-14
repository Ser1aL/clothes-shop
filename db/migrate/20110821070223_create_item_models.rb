class CreateItemModels < ActiveRecord::Migration
  def self.up
    create_table :item_models do |t|
      t.integer :brand_id
      t.integer :category_id
      t.integer :sub_category_id
      t.integer :color_id

      t.timestamps
    end
  end

  def self.down
    drop_table :item_models
  end
end
