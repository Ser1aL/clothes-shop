require 'spec_helper'

describe User do
  context "validation" do
    subject { Factory.build :user }
    it { should be_valid }
    it { should have_many :addresses }
    it { should have_many :comments }
  end

  it "should have accessible addresses" do
    user = Factory.build :user
    user.addresses = [Factory.build(:address, :country => 'USA')]
    user.save
    User.find(user.id).addresses[0].country.should == 'USA'
  end

end
