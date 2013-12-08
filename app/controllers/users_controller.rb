class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def update
    if current_user.update_attributes(params["user"])
      flash[:message_type] = 'profile_updated'
      sign_in current_user, :bypass => true
    else
      flash[:message_type] = 'profile_update_errors'
      flash[:user_update_errors] = current_user.errors.messages.values.flatten
    end
    redirect_to :back
  end

end
