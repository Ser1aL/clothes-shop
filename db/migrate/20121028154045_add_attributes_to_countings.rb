class AddAttributesToCountings < ActiveRecord::Migration
  def self.up
    add_column :countings, :brand_name, :string
    remove_column :countings, :type
  end

  def self.down
    remove_column :countings, :brand_name
    add_column :countings, :type, :string
  end
end
