# frozen_string_literal: true

class AuctionItem < ApplicationRecord
  belongs_to :seller
  has_many :bids

  def max_bid
    bids.maximum(:amount) || self[:max_bid] || 0 # here max_bid could be starting price
  end
end
