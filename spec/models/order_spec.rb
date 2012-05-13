require 'spec_helper'

describe Order do

  context "should be valid" do
    subject { Factory.build(:order) }
    it { should have_many :order_lines }
    it { should be_valid }
  end

  it "should not be saved if no order lines" do
    order = Factory.build(:order)
    order.order_lines = []
    order.save.should == false
  end

end
