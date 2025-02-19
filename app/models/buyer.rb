# frozen_string_literal: true

# Represents a buyer in the system.
class Buyer < ApplicationRecord
  has_secure_password # Automatically handles password hashing
  validates :email, presence: true, uniqueness: true
  has_many :bids, dependent: :destroy
  has_many :transactions, dependent: :destroy
end
