# frozen_string_literal: true

class EmailVerificationsController < ApplicationController
  def verify
    account_type = params[:account_type]
    user_class = account_type == "buyer" ? Buyer : Seller
    user = user_class.find_by(verification_token: params[:token])

    if user.present?
      user.update_columns(verified: true, verification_token: nil)
      flash[:notice] = "Your email has been verified! You can now log in."
      redirect_to login_path(account_type: account_type)
    else
      flash[:alert] = "Invalid or expired verification link."
      redirect_to root_path
    end
  end
end
