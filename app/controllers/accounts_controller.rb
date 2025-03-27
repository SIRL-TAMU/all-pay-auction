# frozen_string_literal: true

# Controller for managing a users account, such as withdrawing and adding funds
class AccountsController < ApplicationController
  before_action :require_login
  include ActionView::Helpers::NumberHelper

  # New method to require login
  def determine_account_type
    if buyer?
      "buyer"
    else
      "seller"
    end
  end

  def require_login
    return if logged_in?

      flash[:alert] = I18n.t("alerts.access_denied")
      redirect_to login_path # Adjust this to your login route
  end

  def manage_funds
    # Add logic for managing funds here
    @balance = current_user.liquid_balance
  end

  def add_funds
    amount = params[:amount].to_f

    if amount <= 0
      flash[:alert] = "Amount must be positive."
      redirect_to manage_funds_path and return
    end

    fixed_percentage = 0.04
    total_fee = (amount * fixed_percentage)
    total_charge = amount + total_fee 
    stripe_amount = (total_charge*100).to_i
    credits = (amount*100).to_i
    session = Stripe::Checkout::Session.create({
                                                 customer_email: current_user.email,
                                                 payment_method_types: [ "card" ],
                                                 line_items: [ {
                                                   price_data: {
                                                     currency: "usd",
                                                     product_data: {
                                                       name: "Purchasing #{number_to_currency(amount)} Auction Credits: "
                                                     },
                                                     unit_amount: stripe_amount
                                                   },
                                                   quantity: 1
                                                 } ],
                                                 mode: "payment",
                                                 success_url: root_url.to_s,
                                                 cancel_url: "#{root_url}/manage_funds",
                                                 metadata: {
                                                   user_id: current_user.id
                                                 },
                                                 payment_intent_data: {
                                                   # application_fee_amount: 0,
                                                   # charge fee does not work with test accounts
                                                   metadata: {
                                                     user_email: current_user.email,
                                                     account_type: determine_account_type,
                                                     credits: credits
                                                   },
                                                   transfer_data: {
                                                     # Already defaults payment to auction house stripe
                                                     #destination: ENV.fetch("STRIPE_ACCOUNT_ID", nil)
                                                   }
                                                 }

                                               }, {
                                                 # Defaults payment to the auction house's Stripe account
                                                 #stripe_account: ENV.fetch("STRIPE_ACCOUNT_ID", nil)
                                               })

    redirect_to session.url, allow_other_host: true
    # Stripe will popup a form to fill in, and our webhook will be listening to events that occur in the stripe form
  end

  def connect_stripe_account
    client_id = ENV.fetch("STRIPE_CONNECT_CLIENT_ID") # Fetch your client ID from .env
    redirect_uri = "#{root_url}stripe/oauth/callback" # Your callback URL after OAuth
    scope = "read_write" # Permissions needed for your platform (read-only is also an option)
  
    oauth_url = "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"
    redirect_to oauth_url, allow_other_host: true
  end

  def stripe_oauth_callback
    if params[:code].present?
      begin
        # Exchange authorization code for access token and stripe_user_id
        response = Stripe::OAuth.token({
          grant_type: "authorization_code",
          code: params[:code]
        })

        stripe_account_id = response.stripe_user_id

        # Save stripe_account_id to current user's record
        current_user.update!(stripe_account_id: stripe_account_id)

        flash[:notice] = "Stripe account successfully connected!"
      rescue Stripe::StripeError => e
        flash[:alert] = "Failed to connect Stripe account: #{e.message}"
      end
    else
      flash[:alert] = "No authorization code received."
    end

    redirect_to manage_funds_path # Redirect back to manage funds or another page
  end

  def disconnect_stripe
    current_user.update(stripe_account_id: nil)
    redirect_to manage_funds_path, notice: "Your Stripe account has been disconnected."
  end

  def withdraw_funds
    amount = params[:amount].to_f

    if amount <= 0
      flash[:alert] = "Amount must be positive."
      redirect_to manage_funds_path and return
    end

    if current_user.liquid_balance < amount
      flash[:alert] = "Insufficient balance."
      redirect_to manage_funds_path and return
    end

    if current_user.stripe_account_id.nil?
      flash[:alert] = "Not connected to Stripe Account."
      redirect_to manage_funds_path and return
    end

    stripe_amount = (amount * 100).to_i # Convert dollars to cents

    begin
      # Create a transfer to the connected account
      transfer = Stripe::Transfer.create({
        amount: stripe_amount,
        currency: "usd",
        destination: current_user.stripe_account_id, # Connected account ID
        metadata: {
          user_id: current_user.id,
          reason: "Auction payout"
        }
      })

      flash[:notice] = "Successfully transferred $#{amount} to your connected Stripe account!"
    rescue Stripe::StripeError => e
      flash[:alert] = "Failed to transfer funds: #{e.message}"
    end

    # Deduct the amount from user's balance (assuming you have a method for this)
    current_user.deduct_funds(amount)


    flash[:notice] = "Successfully withdrew $#{amount}."
    redirect_to manage_funds_path
  end
end
