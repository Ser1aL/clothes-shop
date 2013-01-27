class AddOriginToItemModels < ActiveRecord::Migration
  def change
    add_column :item_models, :origin, :string
  end
end
