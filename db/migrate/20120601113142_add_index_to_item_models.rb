class AddIndexToItemModels < ActiveRecord::Migration
  def self.up
    add_index :item_models, :category_id
    add_index :item_models, :sub_category_id
    add_index :item_models, :brand_id
    add_index :item_models, :gender_id
  end

  def self.down
    remove_index :item_models, :category_id
    remove_index :item_models, :sub_category_id
    remove_index :item_models, :brand_id
    remove_index :item_models, :gender_id
  end
end
