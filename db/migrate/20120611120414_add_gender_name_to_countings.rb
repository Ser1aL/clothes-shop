class AddGenderNameToCountings < ActiveRecord::Migration
  def self.up
    add_column :countings, :gender_name, :string
  end

  def self.down
    remove_column :countings, :gender_name
  end
end
