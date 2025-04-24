# frozen_string_literal: true

# Represents a buyer in the system.
class Buyer < ApplicationRecord
  before_create :generate_verification_token
  has_secure_password # Automatically handles password hashing
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 },
                       format: { with: /\A(?=.*[\p{P}\p{S}]).{8,}\z/,
                                 message: I18n.t("validation.password_format") },
                       if: :password_digest_changed? # Only validate password if it's being changed
  validates :uid, uniqueness: { scope: :provider }, allow_nil: true

  has_many :bids, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :stripe_transactions
  validates :liquid_balance, numericality: { greater_than_or_equal_to: 0 }
  has_many :auction_items, through: :bids
  # Association for auction_items the buyer has won
  has_many :won_auction_items, foreign_key: :winning_buyer_id, class_name: "AuctionItem", dependent: :nullify

  # ensure buyer has enough funds for placing bid
  def sufficient_funds?(bid_amount, auction_item)
    highest_previous_bid = bids.where(auction_item: auction_item).maximum(:amount) || 0
    amount_to_deduct = bid_amount - highest_previous_bid
    liquid_balance >= amount_to_deduct
  end

  # after buyer places bid, subtract from their balance.
  def deduct_funds(bid_amount)
    update(liquid_balance: liquid_balance - bid_amount)
  end

  def generate_password_reset_token
    self.reset_password_token = SecureRandom.urlsafe_base64(24)
    self.reset_password_sent_at = Time.current
    save(validate: false)
  end

  def password_reset_token_valid?
    reset_password_sent_at > 2.hours.ago
  end

  def clear_password_reset_token
    update(reset_password_token: nil, reset_password_sent_at: nil)
  end

  private

  def generate_verification_token
    self.verification_token = SecureRandom.hex(16)
  end
end
