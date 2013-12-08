class Usermail < ActionMailer::Base
  default :from => "customer_service@shop-mydostavka.com"

  def autoregistration(user, random_password)
    @random_password = random_password
    @user = user
    mail :to => "#{@user.full_name} <#{@user.email}>", :subject => t('user_autocreation_successfull')
  end

  def order_details(order)
    @order = order
    @user = order.user
    mail :to => "#{@user.full_name} <#{@user.email}>", :subject => t('order_submitted_successfully'), :from => "customer-service@shop.mydostavka@gmail.com"
  end

  def staff_notification(order)
    @order = order
    @user = order.user
    if Rails.env.development?
      mail :to => "max.reznichenko@gmail.com", :subject => t('new_order')
    else
      mail :to => "Grisha <gri74@bk.ru>", :subject => t('new_order')
    end
  end

  def staff_order_call(phone_number)
    @phone_number = phone_number
    if Rails.env.development?
      mail :to => "max.reznichenko@gmail.com", :subject => t('call_ordered')
    else
      mail :to => "Grisha <gri74@bk.ru>", :subject => t('call_ordered')
    end
  end

end
