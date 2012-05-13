require 'spec_helper'

describe ShoppingCartLine do
  context "validation" do
    subject { Factory.build(:shopping_cart_line) }
    it { should belong_to :product }
    it { should belong_to :shopping_cart }
    it { should be_valid }
  end

  it "should not be created without product" do
    sc_line = Factory.build(:shopping_cart_line)
    sc_line.product = nil
    sc_line.should_not be_valid
  end

  it "should have price identical after been saved" do
    sc_line = Factory.build(:shopping_cart_line)
    before_price = 11.22
    sc_line.price = before_price
    sc_line.save
    ShoppingCartLine.find(sc_line.id).price.should == before_price
  end
end
