class CreateSubCategories < ActiveRecord::Migration
  def self.up
    create_table :sub_categories do |t|
      t.string :name
      t.integer :category_id
      t.string :display_name

      t.timestamps
    end
  end

  def self.down
    drop_table :sub_categories
  end
end
