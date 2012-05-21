class AddOnSaleToStyles < ActiveRecord::Migration
  def self.up
    add_column :styles, :on_sale, :boolean
  end

  def self.down
    remove_column :styles, :on_sale
  end
end
