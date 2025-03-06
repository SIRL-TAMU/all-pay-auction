# frozen_string_literal: true

# Represents a seller in the system.
class Seller < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 },
                       format: { with: /\A(?=.*[\p{P}\p{S}]).{8,}\z/,
                                 message: "must be at least 8 characters long and include at least 1 special character." }

  has_many :transactions, dependent: :destroy
  has_many :auction_items, dependent: :destroy
end
