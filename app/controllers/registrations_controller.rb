class RegistrationsController < ApplicationController
  def new
    @account_type = params[:account_type]
    unless %w[buyer seller].include?(@account_type)
      redirect_to root_path, alert: "Invalid account type"
    end
    @user = @account_type == "buyer" ? Buyer.new : Seller.new
  end

  def create
    account_type = params[:account_type]
    unless %w[buyer seller].include?(account_type)
      redirect_to signup_path, alert: "Invalid account type" and return
    end

    user_class = account_type == "buyer" ? Buyer : Seller
    @user = user_class.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      session[:account_type] = account_type
      redirect_to account_type == "buyer" ? buyer_dashboard_path : seller_dashboard_path, notice: "Welcome, #{account_type.capitalize}!"
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
