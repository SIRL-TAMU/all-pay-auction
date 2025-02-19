# frozen_string_literal: true

# Controller to manage the interface for sellers.
class SellerInterfaceController < ApplicationController
  before_action :ensure_seller

  def index
    # Seller-specific logic (e.g., listing auctions)
  end

  private

  def ensure_seller
    return if logged_in? && seller?

      redirect_to root_path, alert: I18n.t("alerts.access_denied")
  end
end
