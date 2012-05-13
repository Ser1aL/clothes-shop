require 'spec_helper'

describe Category do
  context "should be valid" do
    subject { Factory.build :category }
    it { should be_valid }
    it { should have_many :clock_models }
  end

  it "should not be saved if name is blank" do
    Factory.build(:category, :name => '').should_not be_valid
  end

end
