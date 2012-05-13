class Address < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :country, :city, :phone1, :phone2, :line1
  validates :phone1, :format => { :with => /^[0-9\-\(\)]+$/ }
  validates :phone2, :format => { :with => /^[0-9\-\(\)]+$/ }
  validates :country, :length => { :maximum => 200 }
  validates :city, :length => { :maximum => 200 }
  validates :phone1, :length => { :maximum => 200 }
  validates :phone2, :length => { :maximum => 200 }
  validates :line1, :length => { :maximum => 200 }
end
