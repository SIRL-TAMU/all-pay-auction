# frozen_string_literal: true

# Represents a buyer in the system.
class Buyer < ApplicationRecord
  has_secure_password # Automatically handles password hashing
  validates :email, presence: true, uniqueness: true
  has_many :bids
  has_many :transactions
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  has_many :auction_items, through: :bids


  # ensure buyer has enough funds for placing bid
  def sufficient_funds?(bid_amount)
    amount >= bid_amount
  end

# after buyer places bid, subtract from their balance.
def deduct_funds(bid_amount)
  update(amount: amount - bid_amount)
end
end
