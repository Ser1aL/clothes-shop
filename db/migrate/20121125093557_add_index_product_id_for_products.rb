class AddIndexProductIdForProducts < ActiveRecord::Migration
  def up
    add_index :products, :item_model_id
  end

  def down
    remove_index :products, :item_model_id
  end
end
