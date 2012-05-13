class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.integer :user_id
      t.string :country
      t.string :city
      t.string :line1
      t.string :phone1
      t.string :phone2

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
