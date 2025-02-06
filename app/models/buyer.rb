class Buyer < ApplicationRecord
  has_secure_password # Automatically handles password hashing
  validates :email, presence: true, uniqueness: true
end
