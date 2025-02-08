class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :logged_in?, :buyer?, :seller?

  def current_user  # check is user is logged in, will check database
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

  def require_login
    unless logged_in?
      # redirect_to login_path
      Rails.logger.debug "Debug: You need be logged in!"
    end
  end
end
