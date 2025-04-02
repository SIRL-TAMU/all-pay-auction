# frozen_string_literal: true

# Manages the home page and its associated views.
class HomeController < ApplicationController
  def index
    @auction_items = AuctionItem
                      .includes(:seller, images_attachments: :blob)
                      .where("closing_date >= ? AND is_archived = ?", Time.zone.now, false)
                      .order(opening_date: :asc)
  end
end
