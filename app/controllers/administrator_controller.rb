class AdministratorController < ApplicationController

  before_filter :check_admin

  def orders
    unless params[:order_ids].blank?
      params[:order_ids].each do |order_id|
        Order.find(order_id).update_attribute(:reviewed, true)
      end
    end

    @orders = begin
      if params[:show_reviewed]
        Order.where(:reviewed => true)
      elsif params[:show_unreviewed]
        Order.where(:reviewed => false)
      else
        Order.order(:reviewed).all
      end
    end
    @order = Order.find(params[:order_id]) if params[:order_id]

  end

  def static_pages
    @static_pages = StaticPage.all
    @current_page = StaticPage.find(params[:page_id]) if params[:page_id]
  end

  def change_static_page
    StaticPage.find(params[:page_id]).update_attributes(:text => params[:text])
    redirect_to :back
  end

  def exchange_rates
    @exchange_rates = ExchangeRate.all
  end

  def change_exchange_rate
    ExchangeRate.find(params[:id]).update_attributes(
      :value => params[:value],
      :currency => params[:currency],
      :markup => params[:markup]
    ) and redirect_to :back

  end

  def do_login
    if params[:login] == 'gri74@bk.ru' && params[:password] == 'gri74bkru'
      session[:admin_loginned] = true and redirect_to(administrator_path)
    else
      flash.now[:notice] = 'Login/password combination is incorrect' and render 'login'
    end
  end

private

  def check_admin
    # session[:admin_loginned] = false
    render 'login' if request[:action] != 'do_login' && session[:admin_loginned].blank?
  end
end
