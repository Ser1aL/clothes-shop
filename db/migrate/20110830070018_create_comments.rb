class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id
      t.string :association_id
      t.string :association_type
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
