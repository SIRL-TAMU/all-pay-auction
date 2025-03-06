class AccountsController < ApplicationController
  before_action :require_login

  # New method to require login
  def determine_account_type
    if buyer?
      'buyer'
    else
      'seller'
    end
  end

  
  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this section"
      redirect_to login_path # Adjust this to your login route
    end
  end

  def manage_funds
    # Add logic for managing funds here
    @balance = current_user.liquid_balance
  end

  def add_funds
    amount = params[:amount].to_i

    session = Stripe::Checkout::Session.create({
      customer_email: current_user.email,
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: 'Purchasing All Pay Auction Credits: ',
          },
          unit_amount: amount * 100, # Convert to cents
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: "#{root_url}",
      cancel_url: "#{root_url}/manage_funds",
      metadata: { 
        user_id: current_user.id
      },
      payment_intent_data: {
        #application_fee_amount: 0, # charge fee, does not work with test accounts
        metadata: { 
          user_email: current_user.email,
          account_type: determine_account_type
      },
        transfer_data: {
          destination: ENV['STRIPE_ACCOUNT_ID'], # The auction house's Stripe account ID
        },
      },
    }, {
      stripe_account: ENV['STRIPE_ACCOUNT_ID'] # Use the auction house's Stripe account
    })

    redirect_to session.url, allow_other_host: true


    # Stripe will popup a form to fill in, and our webhook will be listening to events that occur in the stripe form
  end

  end