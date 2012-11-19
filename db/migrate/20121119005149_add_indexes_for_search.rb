class AddIndexesForSearch < ActiveRecord::Migration
  def up
    add_index :brands, :name
    add_index :sub_categories, :name
    add_index :categories, :name
    add_index :item_models, :product_name
  end

  def down
    remove_index :brands, :name
    remove_index :sub_categories, :name
    remove_index :categories, :name
    remove_index :item_models, :product_name
  end
end
