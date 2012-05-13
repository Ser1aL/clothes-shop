require 'spec_helper'

describe ShoppingCart do
  context "validation" do
    subject { Factory.build(:shopping_cart) }
    it { should belong_to :user }
    it { should have_many :shopping_cart_lines }
    it { should be_valid }
  end
end
