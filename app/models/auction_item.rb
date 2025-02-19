# frozen_string_literal: true

class AuctionItem < ApplicationRecord
  belongs_to :seller
  has_many :bids

  def max_bid
    bids.maximum(:amount) || starting_price
  end
end
