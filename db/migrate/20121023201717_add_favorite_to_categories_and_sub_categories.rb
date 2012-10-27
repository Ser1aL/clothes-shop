class AddFavoriteToCategoriesAndSubCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :favorite, :boolean
    add_column :sub_categories, :favorite, :boolean
  end

  def self.down
    remove_column :categories, :favorite
    remove_column :sub_categories, :favorite
  end
end
