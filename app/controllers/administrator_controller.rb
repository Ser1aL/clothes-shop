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

  def brand_favorites
    @brand = Brand.order(:name).all
    @brand_favorites = Brand.find_all_by_favorite(true)
  end

  def set_brand_favorite
    Brand.all.each{|brand| brand.update_attribute(:favorite, false)}
    Brand.find(params[:favorites]).each{|brand| brand.update_attribute(:favorite, true)} unless params[:favorites].blank?
    redirect_to :back
  end

  def category_translates
    @categories = Category.order(:display_name)
    @sub_categories = SubCategory.order(:display_name)
    @genders = Gender.order(:display_name)
  end

  def category_translate
    params[:type].camelize.constantize.find(params["#{params[:type]}_id".to_sym]).update_attributes(
      :display_name => params[:display_name]
    ) unless params[:display_name].blank?
  end

  def brand_translates
    if params[:brand_id]
      @brand = Brand.find(params[:brand_id])
    else
      @brands = Brand.order("name")
    end
  end

  def brand_translate
    Brand.find(params[:brand_id]).update_attribute(:description, params[:description]) and redirect_to :back
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
    render 'login' if request[:action] != 'do_login' && session[:admin_loginned].blank?
  end
end
