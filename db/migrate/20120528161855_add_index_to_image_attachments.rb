class AddIndexToImageAttachments < ActiveRecord::Migration
  def self.up
    add_index :image_attachments, :association_id
  end

  def self.down
    remove_index :image_attachments, :association_id
  end
end
