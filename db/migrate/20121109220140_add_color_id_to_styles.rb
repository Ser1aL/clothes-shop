class AddColorIdToStyles < ActiveRecord::Migration
  def self.up
    add_column :styles, :external_color_id, :integer
  end

  def self.down
    remove_column :styles, :external_color_id
  end
end
