class AddWinningBuyerToAuctionItem < ActiveRecord::Migration[7.2]
  def change
    add_column :auction_items, :winning_buyer_id, foreign_key: { to_table: :buyers }
  end
end
