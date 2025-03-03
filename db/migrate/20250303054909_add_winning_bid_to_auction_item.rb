class AddWinningBidToAuctionItem < ActiveRecord::Migration[7.2]
  def change
    add_reference :auction_items, :winning_buyer, foreign_key: { to_table: :buyers }
  end
end
