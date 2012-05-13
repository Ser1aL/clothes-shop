require 'spec_helper'

describe ClockModel do
  context "should be valid" do
    subject { Factory.build :clock_model }
    it { should be_valid }
    it { should have_one :product }
    it { should belong_to :brand }
    it { should belong_to :sub_category }
    it { should belong_to :category }
    it { should belong_to :color }
    it { should have_many :image_attachments }
    it { should have_many :comments }
  end
  
end
