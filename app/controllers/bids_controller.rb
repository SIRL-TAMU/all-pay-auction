# frozen_string_literal: true

# app/controllers/bids_controller.rb
class BidsController < ApplicationController
    before_action :require_login
    before_action :ensure_buyer

    def create
      @bid = current_user.bids.new(bid_params)
      @auction_item = AuctionItem.find(params[:bid][:auction_item_id])

        if @bid.amount.present?
            if @bid.save
                current_user.deduct_funds(@bid.amount)
                redirect_to auction_items_path, notice: "Bid placed successfully!"
            else
                redirect_to auction_items_path, alert: "Error placing bid. #{@bid.errors.full_messages.join(', ')}"
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
      redirect_to login_path, alert: I18n.t("alerts.access_denied") unless buyer?
    end
end
