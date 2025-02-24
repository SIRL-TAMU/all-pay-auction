# frozen_string_literal: true

# Controller to manage the interface for sellers.
class SellerInterfaceController < ApplicationController
  before_action :ensure_seller

    def index
    @active_or_upcoming_auction = current_user.auction_items
                                              .where(
                                                "opening_date <= ? AND closing_date >= ?",
                                                Time.zone.now,
                                                Time.zone.now
                                              )
                                              .or(current_user.auction_items.where("opening_date > ?", Time.zone.now))
                                              .order(:opening_date)
                                              .first

    @past_auctions = current_user.auction_items
                                 .where(closing_date: ...Time.zone.now)
                                 .order(closing_date: :desc)
    end

  private

  def ensure_seller
    return if logged_in? && seller?

      redirect_to root_path, alert: I18n.t("alerts.access_denied")
  end
end
