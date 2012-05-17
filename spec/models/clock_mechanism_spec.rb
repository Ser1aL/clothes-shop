require 'spec_helper'

describe Gender do
  context "should be valid" do
    subject { Factory.build :color }
    it { should be_valid }
    it { should have_many :clock_models }
  end

  it "should not be saved if name is blank" do
    Factory.build(:color, :name => '').should_not be_valid
  end

end
