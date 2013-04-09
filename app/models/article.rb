class Article < ActiveRecord::Base
  attr_accessible :description, :short_description, :title

  def to_param
    "#{id}-#{title.parameterize}"
  end
end
