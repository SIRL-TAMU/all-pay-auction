# frozen_string_literal: true

# Manages user sessions, including login, logout, and session validation.
class SessionsController < ApplicationController
  def new
    # Renders login form
  end

  def create
    account_type = params[:account_type] # "buyer" or "seller"
    email = params[:email]
    password = params[:password]
    # takes information from login page
    user =
      case account_type
      # TODO, check database items (currently buyer and seller are not tables in db)
      when "buyer" then Buyer.find_by(email: email) # query buyers table in database
      when "seller" then Seller.find_by(email: email) # query sellers table
      end
    if user&.authenticate(password)
      session[:user_id] = user.id # unique id
      session[:account_type] = account_type # cause error if table not in database

      # Redirect based on user type
      if account_type == "buyer"
        redirect_to buyer_dashboard_path, notice: I18n.t("notices.hi_buyer")
        Rails.logger.debug "Debug: Hi Buyer!"
      elsif account_type == "seller"
        redirect_to seller_dashboard_path, notice: I18n.t("notices.hi_seller")
        Rails.logger.debug "Debug: Hi Seller!"
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
end
