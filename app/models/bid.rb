# frozen_string_literal: true

class Bid < ApplicationRecord
  belongs_to :buyer
  belongs_to :auction_item

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :bid_must_be_higher_than_current_max
  validate :buyer_has_sufficient_funds # ensure buyer has enough funds for bid

  def bid_must_be_higher_than_current_max
    return unless amount <= auction_item.max_bid

      errors.add(:amount, "must be higher than the current maximum bid")
  end

  def buyer_has_sufficient_funds
    return if buyer.sufficient_funds?(amount)

      errors.add(:amount, "exceeds your available balance")
  end
end
