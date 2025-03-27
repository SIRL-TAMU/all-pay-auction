# frozen_string_literal: true

# Represents a bid placed by a buyer on an auction item
class Bid < ApplicationRecord
  belongs_to :buyer
  belongs_to :auction_item

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :bid_must_be_higher_than_current_max

  after_create_commit :broadcast_new_bid

  def bid_must_be_higher_than_current_max
    min_valid_bid = BigDecimal(auction_item.max_bid + auction_item.min_increment, 10)
    return if BigDecimal(amount, 10) >= min_valid_bid

    errors.add(:amount, "must be at least #{min_valid_bid.to_f.round(2)}")
  end

  private

  def broadcast_new_bid
    ActionCable.server.broadcast("bids_#{auction_item.id}", {
                                   auction_item_id: auction_item.id,
                                   amount: amount,
                                   buyer_name: buyer.first_name,
                                   created_at: created_at.strftime("%b %d, %Y at %I:%M%p"),
                                   total_bids: auction_item.total_bids
                                 })
  end
end
