class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :body
      t.string :name
      t.string :email
      t.boolean :verified

      t.timestamps
    end
  end
end
