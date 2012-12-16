class AddSideToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :side, :string
  end
end
