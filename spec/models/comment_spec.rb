require 'spec_helper'

describe Comment do
  context "should be valid" do
    subject { Factory.build :comment }
    it { should be_valid }
    it { should belong_to :user }
    it { should belong_to :association }
  end

  before(:each) do
    @comment = Factory.build(:comment)
  end

  it "should not be saved without user_id" do
    @comment.user_id = nil
    @comment.should_not be_valid
  end

  it "should not be saved without association_id" do
    @comment.association_id = nil
    @comment.should_not be_valid
  end

  it "should not be saved without body" do
    @comment.body = ''
    @comment.should_not be_valid
    @comment.body = nil
    @comment.should_not be_valid
  end
end
