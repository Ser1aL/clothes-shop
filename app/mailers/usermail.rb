class Usermail < ActionMailer::Base
  default :from => "customer_service@chasovoy.com"

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

end
