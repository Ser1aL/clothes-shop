class CreateStyles < ActiveRecord::Migration
  def self.up
    create_table :styles do |t|
      t.string :color
      t.decimal :discount_price, :precision => 10, :scale => 2
      t.decimal :original_price, :precision => 10, :scale => 2
      t.integer :product_id
      t.integer :percent_off
      t.string :external_style_id

      t.timestamps
    end
  end

  def self.down
    drop_table :styles
  end
end
