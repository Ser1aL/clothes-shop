class MetaRewrite < ActiveRecord::Base
  attr_accessible :description, :header, :path, :title

  validates_presence_of :path
end
