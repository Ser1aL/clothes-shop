class Usermail < ActionMailer::Base
  default :from => "customer_service@otpravka.com.ua"

  def autoregistration(user, random_password)
    @random_password = random_password
    @user = user
    mail :to => "#{@user.full_name} <#{@user.email}>", :subject => t('user_autocreation_successfull')
  end

  def order_details order
    @order = order
    @user = order.user
    mail :to => "#{@user.full_name} <#{@user.email}>", :subject => t('order_submitted_successfully')
  end

  def staff_notification order
    @order = order
    @user = order.user
    mail :to => "Grisha <gri74@bk.ru>", :subject => t('new_order')
  end

end
