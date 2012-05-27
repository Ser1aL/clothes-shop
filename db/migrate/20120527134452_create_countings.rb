class CreateCountings < ActiveRecord::Migration
  def self.up
    create_table :countings do |t|
      t.integer :category_id
      t.integer :sub_category_id
      t.integer :brand_id
      t.integer :gender_id
      t.integer :value
      t.string :category_name
      t.string :sub_category_name

      t.timestamps
    end
  end

  def self.down
    drop_table :countings
  end
end
