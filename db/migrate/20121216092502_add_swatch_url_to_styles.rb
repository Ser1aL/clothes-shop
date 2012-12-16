class AddSwatchUrlToStyles < ActiveRecord::Migration
  def change
    add_column :styles, :swatch_url, :string
  end
end
