class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.integer :category_id
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :banners
  end
end
