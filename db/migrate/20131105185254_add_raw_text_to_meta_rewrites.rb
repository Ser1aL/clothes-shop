class AddRawTextToMetaRewrites < ActiveRecord::Migration
  def change
    add_column :meta_rewrites, :raw_text, :text
  end
end
