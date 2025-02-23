# frozen_string_literal: true

# Represents an auction item listed by a seller
class AuctionItem < ApplicationRecord
  belongs_to :seller
  has_many :bids, dependent: :destroy

  def max_bid
    bids.maximum(:amount) || self[:max_bid] || 0 # here max_bid could be starting price
  end

  def total_bids
    bids.count
  end

  # Calculate bid pool by summing each user's highest bid
  def bid_pool
    bids.group(:buyer_id).maximum(:amount).values.sum || 0
  end

  def latest_bids(limit = 4)
    bids.includes(:buyer).order(created_at: :desc).limit(limit)
  end
end
