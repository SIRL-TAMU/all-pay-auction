# frozen_string_literal: true

# Represents a buyer in the system.
class Buyer < ApplicationRecord
  has_secure_password # Automatically handles password hashing
  validates :email, presence: true, uniqueness: true
  has_many :bids, dependent: :destroy
  has_many :transactions, dependent: :destroy
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  has_many :auction_items, through: :bids


  # ensure buyer has enough funds for placing bid
  def sufficient_funds?(bid_amount, auction_item)
    highest_previous_bid = bids.where(auction_item: auction_item).maximum(:amount) || 0
    amount_to_deduct = bid_amount - highest_previous_bid
    amount >= amount_to_deduct
  end

# after buyer places bid, subtract from their balance.
def deduct_funds(bid_amount)
  update(amount: amount - bid_amount)
end
end
