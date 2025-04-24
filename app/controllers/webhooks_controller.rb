# frozen_string_literal: true

# Webhooks used to handle Stripe events for payment processing
class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token # Webhooks don’t require CSRF protection

    def stripe
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      endpoint_secret = ENV.fetch("STRIPE_WEBHOOK_SECRET", nil)

      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      rescue JSON::ParserError, Stripe::SignatureVerificationError => e
        render json: { error: e.message }, status: :bad_request and return
      end

      # Handle successful payment
      Rails.logger.debug "This is an attempt to get stuff from stripe"
      case event.type
      when "payment_intent.succeeded"

        session = event["data"]["object"]
        user_email = session["metadata"]["user_email"]
        amount = session["metadata"]["credits"].to_f / 100 # Convert cents to dollars
        account_type = session["metadata"]["account_type"]
        user = if account_type == "buyer"
            Buyer.find_by(email: user_email)
        else
            Seller.find_by(email: user_email)
        end
        if user
            Rails.logger.debug "Update liquid balance??"
          user.update(liquid_balance: user.liquid_balance + amount) # Add funds to balance
          # additionally create a transaction recording in a database for the user
          @stripe_transaction = user.stripe_transactions.new(
            amount: amount,
            transaction_type: "deposit",
            # stripe_transaction_id: transfer.id,  #check on this later TODO
            transaction_date: Time.now
          )

          if @stripe_transaction.save
            Rails.logger.info("Stripe transaction recorded successfully for user #{user.id}.")
          else
            Rails.logger.error("Failed to save Stripe transaction for user #{user.id}: #{stripe_transaction.errors.full_messages.join(", ")}")
          end

        else
            Rails.logger.error("User not found for payment: user_id=#{user_id}, amount=#{amount}")
        end
      when "checkout.session.completed"
            Rails.logger.debug "Session completed"
      else
            Rails.logger.debug { "Unhandled event type: #{event.type}" }

      end
      render json: { status: "success" }
    end
end
