# frozen_string_literal: true

# Base controller class for the application.
# All controllers inherit from this class to share common logic.
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :logged_in?, :buyer?, :seller?

  # check is user is logged in, will check database
  def current_user
    if session[:account_type] == "buyer"
      @current_user ||= Buyer.find_by(id: session[:user_id])
    elsif session[:account_type] == "seller"
      @current_user ||= Seller.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def buyer?
    session[:account_type] == "buyer"
  end

  def seller?
    session[:account_type] == "seller"
  end
end
