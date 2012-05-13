require 'spec_helper'

describe Product do
  context "should be valid" do
    subject { Factory.build(:product) }
    it { should be_valid }
    it { should have_many :order_lines }
    it { should belong_to :clock_model }
  end

  it "should have the price correctly saved" do
    product = Factory.build(:product, :price => 22.11)
    price_before = 22.11
    product.save
    price_after = Product.find(product.id).price
    price_after.should == price_before
  end

  it "should not be saved without model association" do
    product = Factory.build(:product)
    product.clock_model = nil
    product.should_not be_valid
  end
end
