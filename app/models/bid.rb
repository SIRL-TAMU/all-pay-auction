class Bid < ApplicationRecord
  belongs_to :buyer
  belongs_to :auction_item
end
