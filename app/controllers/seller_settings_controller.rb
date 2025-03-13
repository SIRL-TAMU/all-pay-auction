class SellerSettingsController < ApplicationController
  before_action :authenticate_seller!
  before_action :set_seller

  def edit
  end

  def update
    if @seller.update(profile_params)
      redirect_to update_profile_seller_setting_path, notice: "Profile updated successfully"
    else
      flash.now[:alert] = "Profile update failed. Please check your inputs."
      render :edit
    end
  end

  def update_password
    if @seller.authenticate(password_params[:current_password])
      if @seller.update(password_params.except(:current_password))
        redirect_to seller_setting_path, notice: "Password updated successfully"
      else
        flash.now[:alert] = "Password update failed. Please check your inputs."
        render :edit
      end
    else
      flash.now[:alert] = "Invalid current password."
      render :edit
    end
  end

  def destroy
    if @seller.transactions.any? || @seller.auction_items.any?
      flash.now[:alert] = "Cannot delete account with active transactions or auction items."
      render :edit
      return
    end

    if @seller.destroy
      session[:user_id] = nil
      session[:account_type] = nil
      redirect_to root_path, notice: "Account deleted successfully."
    else
      flash.now[:alert] = "Failed to delete account."
      render :edit
    end
  end

  private

  def authenticate_seller!
    unless current_seller
      redirect_to login_path, alert: "Please log in."
    end
  end

  def set_seller
    @seller = current_seller
  end

  def profile_params
    params.require(:seller).permit(:first_name, :last_name)
  end

  def password_params
    params.require(:seller).permit(:current_password, :password, :password_confirmation)
  end

  def current_seller
    Seller.find_by(id: session[:user_id]) if session[:user_id] && session[:account_type] == "seller"
  end
end
