class Banner < ActiveRecord::Base
  has_many :image_attachments, :as => :association
end
