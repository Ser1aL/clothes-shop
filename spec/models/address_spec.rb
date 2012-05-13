require 'spec_helper'

describe Address do
  context 'validation' do
    subject { Factory.build :address }
    it { should be_valid }
    it { should belong_to :user }
  end

end
