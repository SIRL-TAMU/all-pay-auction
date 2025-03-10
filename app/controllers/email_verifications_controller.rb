# frozen_string_literal: true

# This controller handles the email verification process for both buyers and sellers.
class EmailVerificationsController < ApplicationController
  def verify
    account_type = params[:account_type]
    user_class = account_type == "buyer" ? Buyer : Seller
    user = user_class.find_by(verification_token: params[:token])

    if user.present?
      user.assign_attributes(verified: true, verification_token: nil)
      user.save(validate: false)
      flash[:notice] = I18n.t("notices.email_verified")
      redirect_to login_path(account_type: account_type)
    else
      flash[:alert] = I18n.t("errors.invalid_verification")
      redirect_to root_path
    end
  end
end
