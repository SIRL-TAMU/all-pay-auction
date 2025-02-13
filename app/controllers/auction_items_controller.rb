# frozen_string_literal: true

class AuctionItemsController < ApplicationController
  before_action :set_auction_item, only: %i[show edit update destroy]
  before_action :require_seller_login, only: %i[new create edit update destroy]
  before_action :authorize_seller!, only: %i[edit update destroy]

  def index
    @auction_items = AuctionItem.all
  end

  def show
  end

  def new
    @auction_item = current_user.auction_items.build
  end

  def edit
    return if current_user == @auction_item.seller

      redirect_to auction_items_path, alert: "You are not authorized to edit this auction item."
  end

  def create
    @auction_item = current_user.auction_items.build(auction_item_params)

    if @auction_item.save
      redirect_to @auction_item, notice: "Auction item was successfully created."
    else
      render :new
    end
  end

  def update
    if current_user == @auction_item.seller && @auction_item.update(auction_item_params)
      redirect_to @auction_item, notice: "Auction item was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    if current_user == @auction_item.seller
      @auction_item.destroy

      if request.referer.include?(seller_dashboard_path)
        redirect_to seller_dashboard_path, notice: "Auction item was successfully deleted."
      else
        redirect_to auction_items_path, notice: "Auction item was successfully deleted."
      end
    else
      redirect_to auction_items_path, alert: "You are not authorized to delete this auction item."
    end
  end

  private

  def set_auction_item
    @auction_item = AuctionItem.find(params[:id])
  end

  def auction_item_params
    params.require(:auction_item).permit(:name, :description, :max_bid, :opening_date, :closing_date, :image)
  end

  def require_seller_login
    return if seller?

      redirect_to auction_items_path, alert: "Only sellers can perform this action."
  end

  def authorize_seller!
    return if current_user == @auction_item.seller

      redirect_to auction_items_path, alert: "You are not authorized to edit or delete this auction item."
  end
end
