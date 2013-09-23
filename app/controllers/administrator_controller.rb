class AdministratorController < ApplicationController

  before_filter :check_admin
  layout 'administrator'

  def orders
    unless params[:order_ids].blank?
      params[:order_ids].each do |order_id|
        Order.find(order_id).update_attribute(:reviewed, true)
      end
    end

    @orders = begin
      if params[:show_reviewed]
        Order.where(:reviewed => true).order('id desc')
      elsif params[:show_unreviewed]
        Order.where(:reviewed => false).order('id desc')
      else
        Order.order(:reviewed).order('id desc').all
      end
    end
    @order = Order.find(params[:order_id]) if params[:order_id]

  end

  def set_order_status
    Order.find(params[:order_id]).update_attributes!(:status => params[:status].to_sym)
    redirect_to :back
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
    @brand = Brand.order("ifnull(display_name, name)").all
    @brand_favorites = Brand.find_all_by_favorite(true)
  end

  def set_brand_favorite
    Brand.all.each{|brand| brand.update_attribute(:favorite, false)}
    Brand.find(params[:favorites]).each{|brand| brand.update_attribute(:favorite, true)} unless params[:favorites].blank?
    redirect_to :back
  end

  def category_favorites
    @category = Category.order("ifnull(display_name, name)").all
    @category_favorites = Category.find_all_by_favorite(true)
  end

  def set_category_favorite
    Category.all.each{|category| category.update_attribute(:favorite, false)}
    Category.find(params[:favorites]).each{|category| category.update_attribute(:favorite, true)} unless params[:favorites].blank?
    redirect_to :back
  end

  def sub_category_favorites
    @sub_category = SubCategory.order("ifnull(display_name, name)").all
    @sub_category_favorites = SubCategory.find_all_by_favorite(true)
  end

  def set_sub_category_favorite
    SubCategory.all.each{|sub_category| sub_category.update_attribute(:favorite, false)}
    SubCategory.find(params[:favorites]).each{|sub_category| sub_category.update_attribute(:favorite, true)} unless params[:favorites].blank?
    redirect_to :back
  end

  def category_translates
    @categories = Category.order("ifnull(display_name, name)").select('categories.name as original_name, categories.*')
    @sub_categories = SubCategory.order("ifnull(display_name, name)").select('sub_categories.name as original_name, sub_categories.*')
    @genders = Gender.order(:display_name).select('genders.name as original_name, genders.*')
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

  def category_mapping
    @categories = Category.order("ifnull(display_name, name)")
  end

  def set_category_mapping
    @category = Category.find(params[:category_id])
    @category.update_attribute(:top_category, params[:top_category])
  end

  def do_login
    if params[:login] == 'gri74@bk.ru' && params[:password] == 'gri74bkru'
      session[:admin_loginned] = true and redirect_to(administrator_path)
    else
      flash.now[:notice] = 'Login/password combination is incorrect' and render 'login'
    end
  end

  def reviews
    @reviews = Review.order(:verified)
  end

  def verify_review
    Review.find(params[:review_id]).update_attribute(:verified, params[:verified])
  end

  def six_pm
    @count = ItemModel.where(:origin => '6pm').count
  end

  def articles
    @articles = Article.order('id desc').page(params[:page]).per(10)
  end

  def create_article
    Article.create(
        :title => params[:title],
        :description => params[:description],
        :short_description => params[:short_description]
    )
    redirect_to :back
  end

  def edit_article
    @article = Article.find(params[:id])
  end

  def update_article
    Article.find(params[:article_id]).update_attributes(
        :title => params[:title],
        :description => params[:description],
        :short_description => params[:short_description]
    )
    redirect_to :back
  end

private

  def check_admin
    render 'login' if request[:action] != 'do_login' && session[:admin_loginned].blank?
  end
end
