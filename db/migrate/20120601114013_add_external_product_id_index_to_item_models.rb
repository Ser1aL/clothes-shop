class AddExternalProductIdIndexToItemModels < ActiveRecord::Migration
  def self.up
    add_index :item_models, :external_product_id
  end

  def self.down
    add_index :item_models, :external_product_id
  end
end
