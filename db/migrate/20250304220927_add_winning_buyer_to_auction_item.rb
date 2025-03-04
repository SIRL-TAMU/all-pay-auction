class AddWinningBuyerToAuctionItem < ActiveRecord::Migration[7.2]
  def change
    add_column :auction_items, :winning_buyer_id, :bigint
    add_foreign_key :auction_items, :buyers, column: :winning_buyer_id
  end
end
