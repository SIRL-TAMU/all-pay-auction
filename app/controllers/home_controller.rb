# frozen_string_literal: true

# Manages the home page and its associated views.
class HomeController < ApplicationController
  def index
    @auction_items = AuctionItem
                      .includes(:seller, images_attachments: :blob)
                      .where("closing_date >= ? AND is_archived = ?", Time.zone.now, false)
                      .order(opening_date: :asc)
                      .limit(5)
  end

  def load_auction_items
    page = params[:page].to_i
    offset = (page - 1) * 10

    @auction_items = AuctionItem
                      .includes(:seller, images_attachments: :blob)
                      .where("closing_date >= ? AND is_archived = ?", Time.zone.now, false)
                      .order(opening_date: :asc)
                      .offset(offset)
                      .limit(5)

    render partial: "shared/auction_item_cards", locals: { auction_items: @auction_items }, layout: false
  end
end
