class AddIndexOnColorToStyles < ActiveRecord::Migration
  def change
    add_index :styles, :color
  end
end
