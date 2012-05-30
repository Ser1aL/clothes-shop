class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :prepare_counts, :prepare_cart, :set_exchange_rate
  private

  def prepare_counts
    if !request.xhr? and params[:controller] != 'administrator'
      @brand_counts = Brand.favorite_with_counts
      @brand_total_counts = @brand_counts.map{|hash| hash['item_count']}.sum

      @category_counts = ItemModel.counts_by_type(:category)
      @category_total_counts = @category_counts.map{|hash| hash['item_count']}.sum

      @sub_category_counts = ItemModel.counts_by_type(:sub_category)
      @sub_category_total_counts = @sub_category_counts.map{|hash| hash['item_count']}.sum

      @gender_counts = ItemModel.counts_by_type(:gender)
      @gender_total_counts = @gender_counts.map{|hash| hash['item_count']}.sum
    end
  end

  def prepare_cart
    if params[:controller] != 'administrator'
      if session[:shopping_cart_id].nil?
        @cart_line_count = 0
        @shopping_cart = ShoppingCart.new
      else
        @shopping_cart = ShoppingCart.find_or_create_by_id(session[:shopping_cart_id])
        @cart_line_count = @shopping_cart.shopping_cart_lines.size
      end
    end
  end

  def set_exchange_rate
    domain = request.env['SERVER_NAME'].gsub(/www\./, '')
    @exchange_rate, @currency, @markup = begin
      rate = ExchangeRate.find_by_domain(domain)
      [rate.value, rate.currency, rate.markup]
    rescue
      rate = ExchangeRate.first
      [rate.value, rate.currency, rate.markup]
    end
  end
end