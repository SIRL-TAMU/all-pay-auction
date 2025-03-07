class PasswordResetsController < ApplicationController
  def new; end

  def edit
    @token = params[:token]
    @account_type = params[:account_type]
    user_class = @account_type == "buyer" ? Buyer : Seller
    @user = user_class.find_by(reset_password_token: @token)

    return if @user&.password_reset_token_valid?

      redirect_to login_path(account_type: account_type), alert: "Password reset link has expired or is invalid."
  end

  def create
    account_type = params[:account_type]
    email = params[:email]
    user_class = account_type == "buyer" ? Buyer : Seller

    if user_class.find_by(email: email, provider: nil).nil? && user_class.find_by(email: email).present?
      flash[:alert] = "Your account uses Google to login. Please login via Google."
      redirect_to login_path(account_type: account_type) and return
    end

    user = user_class.find_by(email: email, provider: nil)

    if user
      user.generate_password_reset_token
      UserMailer.password_reset_email(user, account_type).deliver_now
    end

    flash[:notice] = "If your email exists, you'll receive password reset instructions shortly."
    redirect_to login_path(account_type: account_type)
  end

  def update
    account_type = params[:account_type]
    token = params[:token]
    user_class = account_type == "buyer" ? Buyer : Seller
    @user = user_class.find_by(reset_password_token: token)

    if @user && @user.password_reset_token_valid?
      if @user.update(password_params)
        @user.clear_password_reset_token
        redirect_to login_path(account_type: account_type), notice: "Your password was successfully updated."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to login_path(account_type: account_type), alert: "Password reset link has expired or is invalid."
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
