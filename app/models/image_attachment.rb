require "open-uri"

class ImageAttachment < ActiveRecord::Base
  belongs_to :association, :polymorphic => true
  has_attached_file :image, :styles => { :thumb => "140x195>", :original => "488x782>" }

  def self.image_from_url(url)
    extname = File.extname(url)
    basename = File.basename(url, extname)
    image_file = Tempfile.new([basename, extname])
    image_file.binmode
    image_file.write open(url).read
    image_file.rewind
    image_file
  end
end