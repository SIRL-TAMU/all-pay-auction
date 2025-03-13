class BuyerSettingsController < ApplicationController
  before_action :authenticate_buyer!
  before_action :set_buyer

  def edit
  end

  def update
    if @buyer.update(profile_params)
      redirect_to update_profile_buyer_setting_path, notice: "Profile updated successfully"
    else
      flash.now[:alert] = "Profile update failed. Please check your inputs."
      render :edit
    end
  end

  def update_password
    if @buyer.authenticate(password_params[:current_password])
      if @buyer.update(password_params.except(:current_password))
        redirect_to buyer_setting_path, notice: "Password updated successfully"
      else
        flash.now[:alert] = "Password update failed. Please check your inputs."
        render :edit
      end
    else
      flash.now[:alert] = "Invalid current password."
      render :edit
    end
  end

  private

  def authenticate_buyer!
    unless current_buyer
      redirect_to login_path, alert: "Please log in."
    end
  end

  def set_buyer
    @buyer = current_buyer
  end

  def profile_params
    params.require(:buyer).permit(:first_name, :last_name)
  end

  def password_params
    params.require(:buyer).permit(:current_password, :password, :password_confirmation)
  end

  def current_buyer
    Buyer.find_by(id: session[:user_id]) if session[:user_id] && session[:account_type] == "buyer"
  end
end
