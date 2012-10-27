require "open-uri"

class ImageAttachment < ActiveRecord::Base
  belongs_to :association, :polymorphic => true
  # has_attached_file :image, :styles => { :thumb => "140x195>", :original => "488x782>" }

  #def self.image_from_url(url)
  #  extname = File.extname(url)
  #  basename = File.basename(url, extname)
  #  image_file = Tempfile.new([basename, extname])
  #  image_file.binmode
  #  image_file.write open(URI::escape(url)).read
  #  image_file.rewind
  #  image_file
  #end

  def zoom_image
    ImageAttachment.where(
      :external_image_type => external_image_type,
      :is_zoomed => true,
      :association_id => association_id,
      :association_type => association_type
    ).try(:first).try(:image_url)
  end
end