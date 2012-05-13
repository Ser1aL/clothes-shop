require 'spec_helper'

describe StaticController do

  describe "GET 'about_us'" do
    it "should be successful" do
      get 'about_us'
      response.should be_success
    end
  end

  describe "GET 'guarantee'" do
    it "should be successful" do
      get 'guarantee'
      response.should be_success
    end
  end

  describe "GET 'payments'" do
    it "should be successful" do
      get 'payments'
      response.should be_success
    end
  end

  describe "GET 'deliveries'" do
    it "should be successful" do
      get 'deliveries'
      response.should be_success
    end
  end

  describe "GET 'contacts'" do
    it "should be successful" do
      get 'contacts'
      response.should be_success
    end
  end

end
