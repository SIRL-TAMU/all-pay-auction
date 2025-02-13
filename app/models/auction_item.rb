class AuctionItem < ApplicationRecord
  belongs_to :seller
  has_many :bids
end
