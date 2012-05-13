class CreateShoppingCarts < ActiveRecord::Migration
  def self.up
    create_table :shopping_carts do |t|
      t.integer :user_id
      t.column :status, :enum, :limit => ['open', 'close'], :default => 'open'
      t.timestamps
    end
  end

  def self.down
    drop_table :shopping_carts
  end
end
