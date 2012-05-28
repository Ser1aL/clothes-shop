class AddIndexToStocks < ActiveRecord::Migration
  def self.up
    add_index :stocks, :style_id
  end

  def self.down
    remove_index :stocks, :style_id
  end
end
