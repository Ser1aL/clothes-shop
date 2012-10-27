class ModifyImageAttachments < ActiveRecord::Migration
  def self.up
    remove_column :image_attachments, :image_file_name
    remove_column :image_attachments, :image_content_type
    remove_column :image_attachments, :image_file_size
    remove_column :image_attachments, :image_updated_at
    add_column :image_attachments, :image_url, :string
    add_column :image_attachments, :external_image_type, :string
    add_column :image_attachments, :is_zoomed, :boolean
  end

  def self.down
    remove_column :image_attachments, :external_image_type
    remove_column :image_attachments, :image_url
    remove_column :image_attachments, :is_zoomed
    add_column :image_attachments, :image_file_name, :string
    add_column :image_attachments, :image_content_type, :string
    add_column :image_attachments, :image_file_size, :string
    add_column :image_attachments, :image_updated_at, :string
  end
end
