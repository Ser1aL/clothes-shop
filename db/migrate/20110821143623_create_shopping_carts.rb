class CreateShoppingCarts < ActiveRecord::Migration
  def self.up
    create_table :shopping_carts do |t|
      t.integer :user_id
      t.string :status, :default => 'open'
      t.timestamps
    end
  end

  def self.down
    drop_table :shopping_carts
  end
end
