# frozen_string_literal: true

# Manages user sessions, including login, logout, and session validation.
class SessionsController < ApplicationController
  def new
    # Renders login form
  end

  def create
    account_type = params[:account_type]
    email = params[:email]
    password = params[:password]

    user = case account_type
    when "buyer" then Buyer.find_by(email: email)
    when "seller" then Seller.find_by(email: email)
    end

    if user&.authenticate(password)
      if user.verified?
        session[:user_id] = user.id
        session[:account_type] = account_type

        redirect_to account_type == "buyer" ? buyer_dashboard_path : seller_dashboard_path,
                    notice: I18n.t("notices.hi_#{account_type}")
      else
        flash[:alert] = "Please verify your email before logging in."
        redirect_to login_path(account_type: account_type)
      end
    else
      flash[:alert] = I18n.t("errors.invalid_credentials")
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:account_type] = nil
    redirect_to root_path, notice: I18n.t("notices.logged_out")
  end

  def google_oauth2_setup_login
    session[:account_type] = params[:account_type] || "buyer"
    session[:oauth_action] = "login"
    redirect_to "/auth/google_oauth2"
  end

  def google_oauth2_setup_register
    session[:account_type] = params[:account_type] || "buyer"
    session[:oauth_action] = "register"
    redirect_to "/auth/google_oauth2"
  end

  def omniauth
    auth = request.env["omniauth.auth"]
    account_type = session[:account_type] || "buyer"
    oauth_action = session[:oauth_action] || "login"

    user_class = account_type == "buyer" ? Buyer : Seller

    @user = user_class.find_by(uid: auth.uid, provider: auth.provider)

    if oauth_action == "login"
      unless @user
        redirect_to login_path(account_type: account_type),
                    alert: "No account found. Please register first." and return
      end
    elsif oauth_action == "register"
      @user ||= user_class.new(uid: auth.uid, provider: auth.provider)

      if @user.new_record?
        @user.assign_attributes(
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          email: auth.info.email,
          password: SecureRandom.base64(16) + "#",
          liquid_balance: 0,
          asset_balance: 0
        )

        unless @user.save
          flash[:alert] = @user.errors.full_messages.to_sentence
          redirect_to signup_path(account_type: account_type) and return
        end
      end
    end

    session[:user_id] = @user.id
    session[:account_type] = account_type

    redirect_to account_type == "buyer" ? buyer_dashboard_path : seller_dashboard_path,
                notice: "Successfully logged in with Google!"
  end
end
