class MetaRewrite < ActiveRecord::Base
  attr_accessible :description, :header, :path, :title, :text_partial, :raw_text

  validates_presence_of :path
end
