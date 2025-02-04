class Buyer < ApplicationRecord
    #has_secure_password  # Enables password hashing & authentication maybe later
    validates :email, presence: true, uniqueness: true
  end   