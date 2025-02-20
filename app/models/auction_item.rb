# frozen_string_literal: true

# Represents an auction item listed by a seller
class AuctionItem < ApplicationRecord
  belongs_to :seller
  has_many :bids, dependent: :destroy

  def max_bid
    bids.maximum(:amount) || self[:max_bid] || 0 # here max_bid could be starting price
  end
end
