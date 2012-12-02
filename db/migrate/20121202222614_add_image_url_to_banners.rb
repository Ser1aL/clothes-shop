class AddImageUrlToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :image_url, :string
  end
end
