class ChangeImageAttachmentsAssociationId < ActiveRecord::Migration
  def self.up
    change_column :image_attachments, :association_id, :integer
  end

  def self.down
    change_column :image_attachments, :association_id, :string
  end
end
