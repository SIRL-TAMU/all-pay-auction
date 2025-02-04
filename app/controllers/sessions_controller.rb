class SessionsController < ApplicationController
  def new
    # Renders login form
  end

  def create
    account_type = params[:account_type]  # "buyer" or "seller"
    email = params[:email]
    password = params[:password]
    # takes information from login page
    user = case account_type
            # TODO, check database items (currently buyer and seller are not tables in db)
           when "buyer" then Buyer.find_by(email: email) #query buyers table in database
           when "seller" then Seller.find_by(email: email) #query sellers table
           end
           
    if user&.authenticate(password)
      session[:user_id] = user.id   #unique id
      session[:account_type] = account_type #cause error if table not in database

      # Redirect based on user type
      if account_type == "buyer"
        redirect_to buyer_dashboard_path, notice: "Hi Buyer!"
        Rails.logger.debug "Debug: Hi Buyer!"
      elsif account_type == "seller"
        redirect_to seller_dashboard_path, notice: "Hi Seller!"
        Rails.logger.debug "Debug: Hi Seller!"
      end
    else    
      flash[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:account_type] = nil
    redirect_to root_path, notice: "Logged out!"
  end
end