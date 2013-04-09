class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :short_description
      t.text :description

      t.timestamps
    end
  end
end
