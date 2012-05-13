require 'spec_helper'

describe AdministratorController do

  describe "GET 'orders'" do
    it "should be successful" do
      get 'orders'
      response.should be_success
    end
  end

end
