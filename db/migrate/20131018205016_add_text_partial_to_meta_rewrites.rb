class AddTextPartialToMetaRewrites < ActiveRecord::Migration
  def change
    add_column :meta_rewrites, :text_partial, :string
  end
end
