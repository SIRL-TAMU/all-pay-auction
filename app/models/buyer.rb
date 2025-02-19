# frozen_string_literal: true

# Represents a buyer in the system.
class Buyer < ApplicationRecord
  has_secure_password # Automatically handles password hashing
  validates :email, presence: true, uniqueness: true
  has_many :bids
  has_many :transactions
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  def sufficient_funds?(bid_amount) # ensure buyer has enough funds for placing bid
    amount >= bid_amount
  end

def deduct_funds(bid_amount)  #after buyer places bid, subtract from their balance.
  update(amount: amount - bid_amount)
end

end
