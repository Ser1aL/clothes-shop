class AddTopCategoryToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :top_category, :integer
  end

  def self.down
    remove_column :categories, :top_category
  end
end
