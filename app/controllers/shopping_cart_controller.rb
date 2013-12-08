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

    selected_stock_size = @stock.size
    exists = true

    unless Rails.env.development?
      if @product.item_model.origin == '6pm' || @product.item_model.origin.blank?
        begin
          exists = @style.update_6pm_prices(@product.item_model)
          Rails.logger.debug "Exists at 6pm: #{exists.inspect}"
        rescue => e
          Rails.logger.debug '---------GOT 6pm EXCEPTION---------------'
          Rails.logger.debug e.inspect
          Rails.logger.debug e.message
          Rails.logger.debug '------------------------'
        end
      end

      if ( @product.item_model.origin == 'zappos' || @product.item_model.origin.blank? ) && !exists
        begin
          exists = @style.update_zappos_prices(@product.item_model)
          Rails.logger.debug "Exists at zappos: #{exists.inspect}"
        rescue => e
          Rails.logger.debug '---------GOT zappos EXCEPTION---------------'
          Rails.logger.debug e.inspect
          Rails.logger.debug e.message
          Rails.logger.debug '------------------------'
        end
      end
    end

    if exists
      @style.update_attribute(:hidden, false)
    else
      @style.update_attribute(:hidden, true)
      flash[:message_type] = 'product_does_not_exist'
      redirect_to :back and return
    end

    @product = Product.find(params[:product_id]) rescue nil
    @style = @product.styles.find(params[:style]) rescue nil
    @stock = @style.stocks.where(size: selected_stock_size).first rescue nil

    if @product && @style && @stock
      if session[:shopping_cart_id].nil?
        @shopping_cart = ShoppingCart.create!(:user_id => nil, :status => :open)
        @shopping_cart.shopping_cart_lines.create(
          :product_id => params[:product_id],
          :quantity => 1,
          :price => @style.discount_price_extra(@exchange_rate, @markup, @fixed_markup),
          :style => @style,
          :stock_size => @stock.size,
          :currency => @currency
        )
        session[:shopping_cart_id] = @shopping_cart.id
      else
        @shopping_cart = ShoppingCart.find(session[:shopping_cart_id])
        if @shopping_cart_line = @shopping_cart.shopping_cart_lines.find_by_product_id_and_style_id_and_stock_size(params[:product_id], params[:style], @stock.size)
          @shopping_cart_line.increment!(:quantity)
        else
          @shopping_cart.shopping_cart_lines.create(
            :product_id => params[:product_id],
            :quantity => 1,
            :price => @style.discount_price_extra(@exchange_rate, @markup, @fixed_markup),
            :style => @style,
            :stock_size => @stock.size,
            :currency => @currency
          )
        end
      end
    else
      flash[:message_type] = 'product_with_this_size_does_not_exist'
      redirect_to :back and return
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

  def create_order
    user = begin
      if current_user
        current_user
      elsif finding = User.find_by_email(params[:user][:email])
        finding
      else
        User.auto_create(params[:user])[:user]
      end
    end

    if user
      @order = Order.create(
        :address => params[:address],
        :city => params[:city],
        :country => params[:country],
        :order_time => @shopping_cart.created_at,
        :status => :submitted,
        :user => user,
        :delivery_city => params[:order_delivery]
      )

      @shopping_cart.shopping_cart_lines.each do |sc_line|
        @order.order_lines.create(
          :price => sc_line.price,
          :product => sc_line.product,
          :quantity => sc_line.quantity,
          :style => sc_line.style,
          :currency => @currency,
          :stock_size => sc_line.stock_size
        )
      end
      if @order.new_record?
        @order_validation_errors = @order.errors
        render :action => 'payment'
      else

        @order.update_total
        @shopping_cart.close
        @order.user.update_attribute(:phone_number, params[:user][:phone_number])

        Usermail.order_details(@order).deliver
        Usermail.staff_notification(@order).deliver

        session[:shopping_cart_id] = nil
        flash[:message_type] = 'order_submitted_successfully'
        flash[:order_id] = @order.id
        redirect_to root_path
      end
    else
      @user_validation_errors = User.auto_create(params[:user])[:validation_errors]
      render 'show'
    end
  end

  def mark_callback
    if Digest::SHA1.hexdigest(params[:order_id]) == params[:update_token]
      Order.find(params[:order_id]).update_attributes(:callback => params[:callback])
    end
    render nothing: true
  end

  private
  
  def redirect_if_no_shopping_cart
    @shopping_cart = ShoppingCart.find(session[:shopping_cart_id])
    raise if @shopping_cart.total.to_i == 0
    rescue
      redirect_to root_path
  end
  
end
