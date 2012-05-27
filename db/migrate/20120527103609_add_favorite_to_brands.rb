class AddFavoriteToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :favorite, :boolean
  end

  def self.down
    remove_column :brands, :favorite
  end
end
