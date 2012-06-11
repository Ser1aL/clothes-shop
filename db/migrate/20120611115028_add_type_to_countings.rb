class AddTypeToCountings < ActiveRecord::Migration
  def self.up
    add_column :countings, :type, :string
  end

  def self.down
    remove_column :countings, :type
  end
end
