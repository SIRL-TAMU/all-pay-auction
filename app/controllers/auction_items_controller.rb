# frozen_string_literal: true

# Controller for managing auction items, including CRUD operations
class AuctionItemsController < ApplicationController
  before_action :set_auction_item, only: %i[show edit update destroy]
  before_action :require_seller_login, only: %i[new create edit update destroy]
  before_action :authorize_seller!, only: %i[edit update destroy]

  def index
    @auction_items = AuctionItem.all
  end

  def show; end

  def new
    @auction_item = current_user.auction_items.build
  end

  def edit
    return if current_user == @auction_item.seller

    redirect_to auction_items_path, alert: t("errors.unauthorized_edit")
  end

  def create
    @auction_item = current_user.auction_items.build(auction_item_params.except(:images))

    if @auction_item.save
      if params[:auction_item][:images].present?
        params[:auction_item][:images].each do |image|
          @auction_item.images.attach(image)
        end
      end

      redirect_to seller_dashboard_path, notice: t("notices.auction_item_created")
    else
      render :new
    end
  end

  def update
    if current_user == @auction_item.seller
      if params[:auction_item][:images].present?
        params[:auction_item][:images].each do |image|
          @auction_item.images.attach(image)
        end
      end

      if @auction_item.update(auction_item_params.except(:images))
        redirect_to @auction_item, notice: t("notices.auction_item_updated")
      else
        render :edit
      end
    else
      redirect_to auction_items_path, alert: t("errors.unauthorized_edit")
    end
  end

  def destroy
    if current_user == @auction_item.seller
      @auction_item.destroy

      redirect_path = if request.referer.present? && request.referer.include?(seller_dashboard_path)
                        seller_dashboard_path
      else
                        auction_items_path
      end

      redirect_to redirect_path, notice: t("notices.auction_item_deleted")
    else
      redirect_to auction_items_path, alert: t("errors.unauthorized_delete")
    end
  end

  def remove_image
    @auction_item = AuctionItem.find(params[:id])
    image = @auction_item.images.find_by(blob_id: params[:image_id])

    if image
      image.purge
      flash[:success] = t("notices.image_removed")
    else
      flash[:error] = t("errors.image_not_found")
    end

    redirect_to edit_auction_item_path(@auction_item)
  end

  private

  def set_auction_item
    @auction_item = AuctionItem.find(params[:id])
  end

  def auction_item_params
    params.require(:auction_item).permit(
      :name, :description, :curr_max_bid, :min_increment, :innate_value,
      :opening_date, :closing_date, :is_archived, :item_type, :names_visible,
      :bid_amount_visible, images: [])
  end

  def require_seller_login
    return if seller?

    redirect_to auction_items_path, alert: t("errors.only_sellers")
  end

  def authorize_seller!
    return if current_user == @auction_item.seller

    redirect_to auction_items_path, alert: t("errors.unauthorized_edit_delete")
  end

  def ensure_non_seller_access
    if logged_in? && seller?
      nil
    elsif !logged_in? || (!seller? && !buyer?)
      redirect_to login_path(account_type: "buyer"), alert: I18n.t("alerts.login_required_buyer")
    end
  end
end
