class CreateBrands < ActiveRecord::Migration
  def self.up
    create_table :brands do |t|
      t.string :name
      t.text :description
      t.string :external_brand_id
      t.string :logo_url
      t.string :display_name

      t.timestamps
    end
  end

  def self.down
    drop_table :brands
  end
end
