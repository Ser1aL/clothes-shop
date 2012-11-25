class AddPriceIndexToStyles < ActiveRecord::Migration
  def up
    add_index :styles, :discount_price
  end

  def down
    remove_index :styles, :discount_price
  end
end
