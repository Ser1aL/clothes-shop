require "open-uri"

class ImageAttachment < ActiveRecord::Base
  belongs_to :association, :polymorphic => true
  has_attached_file :image, :styles => { :thumb => "106x173#", :original => "488x782>" }

  def image_from_url(url)
    self.image = open(url)
  end
end
