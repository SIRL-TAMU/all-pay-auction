# frozen_string_literal: true

# Handles user registration logic, including account type and creation.
class RegistrationsController < ApplicationController
  def new
    @account_type = params[:account_type]
    redirect_to root_path, alert: I18n.t("alerts.invalid_account_type") unless %w[buyer seller].include?(@account_type)
    @user = @account_type == "buyer" ? Buyer.new : Seller.new
  end

  def create
    @account_type = params[:account_type]
    unless %w[buyer seller].include?(@account_type)
      redirect_to signup_path, alert: I18n.t("alerts.invalid_account_type") and return
    end

    user_class = @account_type == "buyer" ? Buyer : Seller
    @user = user_class.new(user_params)
    @user.liquid_balance = 0
    @user.asset_balance = 0

    if @user.save
      UserMailer.verification_email(@user).deliver_now

      flash[:notice] = "Please check your email to verify your account before logging in."
      redirect_to login_path(account_type: @account_type)
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
