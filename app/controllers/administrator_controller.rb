class AdministratorController < ApplicationController

  before_filter :check_admin

  def orders
    @orders = Order.all
  end

private

  def check_admin
    redirect_to root_path if !current_user or current_user.email != 'max.reznichenko@gmail.com' 
  end
end
