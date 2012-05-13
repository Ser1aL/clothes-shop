class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.timestamp :order_time
      t.column :status, :enum, :limit => [:submitted, :paid, :sent]
      t.column :delivery_type, :enum, :limit => [:postal_service, :autolux, :intime, :night_express, :pickup, :nova_postal_service]

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
