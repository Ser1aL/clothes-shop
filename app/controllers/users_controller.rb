class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def update
    current_user.update_attributes(params["user"])
    redirect_to :back
  end

end
