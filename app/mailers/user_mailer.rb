# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  default from: "swirl.allpayauction@gmail.com"

  def verification_email(user)
    @user = user
    account_type = user.is_a?(Buyer) ? "buyer" : "seller"
    @verification_link = verify_user_url(token: @user.verification_token, account_type: account_type)
    mail(to: @user.email, subject: "Verify Your Account")
  end
end
