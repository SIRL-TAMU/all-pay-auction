# frozen_string_literal: true

# Represents a seller in the system.
class Seller < ApplicationRecord
  has_secure_password # Automatically handles password hashing
  validates :email, presence: true, uniqueness: true
  has_many :transactions
  has_many :auction_items, dependent: :destroy
  # required to render seller dashboard
end
