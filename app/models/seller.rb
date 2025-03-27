# frozen_string_literal: true

# Represents a seller in the system.
class Seller < ApplicationRecord
  before_create :generate_verification_token
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 },
                       format: { with: /\A(?=.*[\p{P}\p{S}]).{8,}\z/,
                                 message: I18n.t("validation.password_format") },
                       if: :password_digest_changed? # Only validate password if it's being changed
  validates :uid, uniqueness: { scope: :provider }, allow_nil: true

  has_many :transactions, dependent: :destroy
  has_many :auction_items, dependent: :destroy

  def generate_password_reset_token
    self.reset_password_token = SecureRandom.urlsafe_base64(24)
    self.reset_password_sent_at = Time.current
    save(validate: false)
  end

  def password_reset_token_valid?
    reset_password_sent_at > 2.hours.ago
  end

  # After seller withdraws, deduct funds
  def deduct_funds(bid_amount)
    update(liquid_balance: liquid_balance - bid_amount)
  end

  def clear_password_reset_token
    update(reset_password_token: nil, reset_password_sent_at: nil)
  end

  private

  def generate_verification_token
    self.verification_token = SecureRandom.hex(16)
  end
end
