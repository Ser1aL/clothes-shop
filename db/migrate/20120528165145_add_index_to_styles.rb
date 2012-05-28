class AddIndexToStyles < ActiveRecord::Migration
  def self.up
    add_index :styles, :product_id
  end

  def self.down
    remove_index :styles, :product_id
  end
end
