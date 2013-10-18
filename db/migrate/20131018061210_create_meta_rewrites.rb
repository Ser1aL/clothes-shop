class CreateMetaRewrites < ActiveRecord::Migration
  def change
    create_table :meta_rewrites do |t|
      t.string :path
      t.text :title
      t.text :description
      t.text :header

      t.timestamps
    end
  end
end
