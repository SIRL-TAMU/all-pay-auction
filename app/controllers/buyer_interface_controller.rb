# frozen_string_literal: true

# Controller to manage the interface for buyers.
class BuyerInterfaceController < ApplicationController
  before_action :ensure_buyer

  def index
    @bidded_items = current_user.bids.includes(:auction_item).map(&:auction_item).uniq
  end

  private

  def ensure_buyer
    # if !buyer?
    #   flash[:alert] = "Invalid email or password"
    #   Rails.logger.debug "are you a buyer"

    # end
    return if logged_in? && buyer?

      redirect_to root_path, alert: I18n.t("alerts.access_denied")
  end
end
