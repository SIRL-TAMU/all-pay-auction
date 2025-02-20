# frozen_string_literal: true

# Represents an auction item listed by a seller
class AuctionItem < ApplicationRecord
  belongs_to :seller
  has_many :bids, dependent: :destroy
end
