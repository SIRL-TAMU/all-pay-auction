class AddHideBiddingHistoryToAuctionItems < ActiveRecord::Migration[7.0]
  def change
    add_column :auction_items, :hide_bidding_history, :boolean, default: false, null: false
  end
end