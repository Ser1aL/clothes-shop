class ShoppingCartController < ApplicationController

  before_filter :redirect_if_no_shopping_cart, :only => [:payment, :create_order, :review]

  def show
    if session[:shopping_cart_id].nil?
        @shopping_cart = ShoppingCart.new(:user_id => nil, :status => 'open')
        session[:shopping_cart_id] = @shopping_cart.id
    else
        @shopping_cart = ShoppingCart.find(session[:shopping_cart_id])
    end
  end

  def add_to_cart
    @product = Product.find(params[:product_id])
    @style = @product.styles.find(params[:style])
    @stock = @style.stocks.find(params[:stock_id])

    if @product && @style && @stock
      if session[:shopping_cart_id].nil?
        @shopping_cart = ShoppingCart.create(:user_id => nil, :status => 'open')
        @shopping_cart.shopping_cart_lines.create(
          :product_id => params[:product_id],
          :quantity => 1,
          :price => @style.discount_price_extra,
          :style => @style,
          :stock => @stock
        )
        session[:shopping_cart_id] = @shopping_cart.id
      else
        @shopping_cart = ShoppingCart.find(session[:shopping_cart_id])
        if @shopping_cart_line = @shopping_cart.shopping_cart_lines.find_by_product_id_and_style_id_and_stock_id(params[:product_id], params[:style], params[:stock_id])
          @shopping_cart_line.increment!(:quantity)
        else
          @shopping_cart.shopping_cart_lines.create(
            :product_id => params[:product_id],
            :quantity => 1,
            :price => @style.discount_price_extra,
            :style => @style,
            :stock => @stock
          )
        end
      end
    end
    prepare_cart
    render 'show'
  end

  def change_quantity
    @shopping_cart_line = ShoppingCartLine.find(params[:cart_line_id])
    return if @shopping_cart_line.nil? or @shopping_cart_line.shopping_cart.id != session[:shopping_cart_id]
    @quantity = params[:quantity].to_i
    @shopping_cart_line.update_attribute(:quantity, @quantity)
  end
  
  def remove_cart_line
    @shopping_cart_line = ShoppingCartLine.find(params[:cart_line_id])
    return if @shopping_cart_line.nil? or @shopping_cart_line.shopping_cart.id != session[:shopping_cart_id]
    @shopping_cart = @shopping_cart_line.shopping_cart
    @shopping_cart_line.destroy
  end

  def payment
    if Order.valid_attribute?(:address, params[:address]) && Order.valid_attribute?(:city, params[:city]) && User.valid_attribute?(:phone_number, params[:phone_number])
      params[:user] ||= {}
    else
      @address_validation_errors = [I18n.t('invalid_address_information')]
      render :action => 'show'
    end
  end

  def review
    @user = current_user ? current_user : User.new(params[:user].merge(
      { :password => 'fake_password', 
        :password_confirmation => 'fake_password',
        :phone_number => params[:phone_number] }))
    if @user.valid?
      @order = Order.new(
          :delivery_type => params[:delivery_type],
          :payment_type => params[:payment_type],
          :address => params[:address],
          :city => params[:city],
          :order_time => @shopping_cart.created_at,
          :status => :submitted,
          :user => @user
        )
      @shopping_cart.shopping_cart_lines.each do |sc_line|
        @order.order_lines << OrderLine.new(:price => sc_line.price, :product => sc_line.product, :quantity => sc_line.quantity)
      end
      unless @order.valid?
        @order_validation_errors = @order.errors
        render :action => 'payment'
      end
    else
      @user_validation_errors = @user.errors
      render :action => 'payment'
    end
  end

  def create_order
    user = current_user ? current_user : User.auto_create(params[:user].merge({ :phone_number => params[:phone_number] }))[:user]
    if user
      @order = Order.create(
        :delivery_type => params[:delivery_type],
        :payment_type => params[:payment_type],
        :address => params[:address],
        :city => params[:city],
        :order_time => @shopping_cart.created_at,
        :status => :submitted,
        :user => user
      )

      @shopping_cart.shopping_cart_lines.each do |sc_line|
        @order.order_lines.create(
          :price => sc_line.price,
          :product => sc_line.product,
          :quantity => sc_line.quantity,
          :style => sc_line.style
        )
      end
      if @order.new_record?
        @order_validation_errors = @order.errors
        render :action => 'payment'
      else
        @order.update_total
        @shopping_cart.close
        @order.user.update_attribute(:address, params[:address]) if !@order.user.address
        @order.user.update_attribute(:city, params[:city]) if !@order.user.city
        @order.user.update_attribute(:phone_number, params[:phone_number])
        Usermail.order_details(@order).deliver
        session[:shopping_cart_id] = nil
        flash[:message_type] = 'order_submitted_successfully'
        flash[:order_id] = @order.id
        redirect_to root_path
      end      
    else
      @user_validation_errors = User.auto_create(params[:user])[:validation_errors]
      render :action => 'payment'
    end
  end

  private
  
  def redirect_if_no_shopping_cart
    @shopping_cart = ShoppingCart.find(session[:shopping_cart_id])
    raise if @shopping_cart.total.to_i == 0
    rescue
      redirect_to root_path
  end
  
end
