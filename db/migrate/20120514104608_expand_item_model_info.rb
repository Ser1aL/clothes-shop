class ExpandItemModelInfo < ActiveRecord::Migration
  def self.up
    add_column :item_models, :external_product_id, :string
    add_column :item_models, :product_name, :string
    add_column :item_models, :video_url, :string
    add_column :item_models, :weight, :string
  end

  def self.down
    remove_column :item_models, :external_product_id, :product_name, :gender, :video_url, :weight
  end
end
