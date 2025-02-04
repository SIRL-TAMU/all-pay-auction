class SellerInterfaceController < ApplicationController
  before_action :require_login
  before_action :ensure_seller

  def index
    # Seller-specific logic (e.g., listing auctions)
  end

  private

  def ensure_seller
    redirect_to root_path, alert: "Access denied!" unless seller?
  end
end
