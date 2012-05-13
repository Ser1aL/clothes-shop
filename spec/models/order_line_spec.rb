require 'spec_helper'

describe OrderLine do

  context "should be valid" do
    subject { Factory.build(:order_line) }
    it { should be_valid }
    it { should belong_to :order }
    it { should belong_to :product }
  end

  it "should have a positive quantity" do
    order_line = Factory(:order_line)
    order_line.quantity = -1
    order_line.should_not be_valid
  end

  it "should not be saved without product" do
    order = Factory.build(:order_line)
    order.product = nil
    order.save.should == false
  end

end
