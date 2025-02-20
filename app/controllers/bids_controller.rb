# frozen_string_literal: true

# app/controllers/bids_controller.rb
class BidsController < ApplicationController
    before_action :ensure_buyer

    def create
      @bid = current_user.bids.new(bid_params)
      @auction_item = AuctionItem.find(params[:bid][:auction_item_id])
      highest_previous_bid = current_user.bids.where(auction_item: @auction_item).maximum(:amount) || 0
        if @bid.amount.present?
            if current_user.sufficient_funds?(@bid.amount, @auction_item)   # make sure user has enough money to place the bid
                if @bid.save
                    amount_to_charge = @bid.amount - highest_previous_bid
                    current_user.deduct_funds(amount_to_charge)
                    redirect_to auction_items_path, notice: "Bid placed successfully!"
                else
                    redirect_to auction_items_path, alert: "Error placing bid. #{@bid.errors.full_messages.join(', ')}"
                end
            else
                redirect_to auction_items_path, alert: 'Insufficient funds to place this bid.'
            end
        else
            redirect_to auction_items_path, alert: "Please enter a bid amount."
        end
    end

  private

    def bid_params
      params.require(:bid).permit(:amount, :auction_item_id)
    end

    def ensure_buyer
        return if logged_in? && buyer?
          redirect_to root_path, alert: I18n.t("alerts.access_denied")
      end
    
end
