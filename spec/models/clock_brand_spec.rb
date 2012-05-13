require 'spec_helper'

describe Brand do

  context "should be valid" do
    subject { Factory.build :brand }
    it { should be_valid }
    it { should have_many :clock_models }
  end

  before(:each) do
    Brand.destroy_all
  end

  it "should not be saved if name is blank" do
    Factory.build(:brand, :name => '').should_not be_valid
  end
  
  it "should return unique brands" do
    brand1 = Factory(:brand, :name =>"brand1")
    brand2 = Factory(:brand, :name =>"brand2")
    brand3 = Factory(:brand, :name =>"brand3")
    Brand.all_distinct.should == [["brand1", brand1.id], ["brand2", brand2.id], ["brand3", brand3.id]]
  end

end
