class Style < ActiveRecord::Base
  belongs_to :product
  has_many :image_attachments, :as => :association
  has_many :stocks
end
