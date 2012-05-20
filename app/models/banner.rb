class Banner < ActiveRecord::Base
  belongs_to :category
  has_many :image_attachments, :as => :association
end
