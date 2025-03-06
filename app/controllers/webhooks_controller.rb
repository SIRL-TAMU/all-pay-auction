class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token  # Webhooks don’t require CSRF protection
  
    def stripe
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
  
      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      rescue JSON::ParserError, Stripe::SignatureVerificationError => e
        render json: { error: e.message }, status: 400 and return
      end
  
      # Handle successful payment
      Rails.logger.debug "This is an attempt to get stuff from stripe"
      case event.type
      when 'payment_intent.succeeded'

        session = event['data']['object']
        user_email = session['metadata']['user_email']
        amount = session['amount'] / 100  # Convert cents to dollars
        account_type = session['metadata']['account_type']
        if account_type == 'buyer'
            user = Buyer.find_by(email: user_email)
        else 
            user = Seller.find_by(email: user_email)
        end 
        if user
            Rails.logger.debug "Update liquid balance??"
          user.update(liquid_balance: user.liquid_balance + amount)  # Add funds to balance
        else
            Rails.logger.error("User not found for payment: user_id=#{user_id}, amount=#{amount}")
        end
        when 'checkout.session.completed'
            Rails.logger.debug "Session completed"
        else 
            Rails.logger.debug "Unhandled event type: #{event.type}"

      end
      render json: { status: 'success' }
    end

  end