class AddHiddenToStyles < ActiveRecord::Migration
  def self.up
    add_column :styles, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :styles, :hidden
  end
end
