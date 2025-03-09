# frozen_string_literal: true

# This controller handles the password reset process for both buyers and sellers.
class PasswordResetsController < ApplicationController
  def new; end

  def edit
    @token = params[:token]
    @account_type = params[:account_type]
    user_class = @account_type == "buyer" ? Buyer : Seller
    @user = user_class.find_by(reset_password_token: @token)

    return if @user&.password_reset_token_valid?

      redirect_to login_path(account_type: account_type), alert: I18n.t("notices.password_reset_invalid")
  end

  def create
    account_type = params[:account_type]
    email = params[:email]
    user_class = account_type == "buyer" ? Buyer : Seller

    if user_class.find_by(email: email, provider: nil).nil? && user_class.find_by(email: email).present?
      flash[:alert] = I18n.t("notices.errors.google_login_required")
      redirect_to login_path(account_type: account_type) and return
    end

    user = user_class.find_by(email: email, provider: nil)

    if user
      user.generate_password_reset_token
      UserMailer.password_reset_email(user, account_type).deliver_now
    end

    flash[:notice] = I18n.t("mailers.reset_password")
    redirect_to login_path(account_type: account_type)
  end

  def update
    account_type = params[:account_type]
    token = params[:token]
    user_class = account_type == "buyer" ? Buyer : Seller
    @user = user_class.find_by(reset_password_token: token)

    if @user&.password_reset_token_valid?
      if @user.update(password_params)
        @user.clear_password_reset_token
        redirect_to login_path(account_type: account_type),
                    notice: flash[:notice] = I18n.t("notices.password_reset_success")
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to login_path(account_type: account_type), alert: I18n.t("notices.password_reset_invalid")
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
