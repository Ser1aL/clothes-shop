class MetaRewrite < ActiveRecord::Base
  attr_accessible :description, :header, :path, :title, :text_partial

  validates_presence_of :path
end
