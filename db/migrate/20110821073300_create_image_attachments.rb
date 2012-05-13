class CreateImageAttachments < ActiveRecord::Migration
  def self.up
    create_table :image_attachments do |t|
      t.string :association_id
      t.string :association_type
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.string :image_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :image_attachments
  end
end
