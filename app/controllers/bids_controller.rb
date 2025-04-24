# frozen_string_literal: true

# app/controllers/bids_controller.rb
class BidsController < ApplicationController
    before_action :ensure_buyer

    def create
      @auction_item = AuctionItem.find(params[:bid][:auction_item_id])
      if @auction_item.closed? || @auction_item.archived? 
        redirect_to auction_item_path(@auction_item), alert: "This auction has ended. You cannot place a bid."
        return
      end
      @bid = current_user.bids.new(bid_params)

      highest_previous_bid = current_user.bids.where(auction_item: @auction_item).maximum(:amount) || 0

      if @bid.amount.present?
        if current_user.sufficient_funds?(@bid.amount, @auction_item) # Ensure user has enough funds for bid
          if @bid.save
            amount_to_charge = @bid.amount - highest_previous_bid
            current_user.deduct_funds(amount_to_charge)
            redirect_to auction_item_path(@auction_item), notice: I18n.t("bids.create.success")
          else
            redirect_to auction_item_path(@auction_item),
                        alert: "#{I18n.t('bids.create.bid_error')} #{@bid.errors.full_messages.join(', ')}"
          end
        else
          redirect_to auction_item_path(@auction_item), alert: I18n.t("bids.create.insufficient_funds")
        end
      else
        redirect_to auction_item_path(@auction_item), alert: I18n.t("bids.create.missing_amount")
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
