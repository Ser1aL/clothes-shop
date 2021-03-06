class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.timestamp :order_time
      t.string :status
      t.boolean :reviewed, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
