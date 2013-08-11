class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :prepare_cart, :set_exchange_rate
  private

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