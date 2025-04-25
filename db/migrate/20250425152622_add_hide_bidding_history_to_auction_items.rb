class AddHideBiddingHistoryToAuctionItems < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:auction_items, :hide_bidding_history)
      add_column :auction_items, :hide_bidding_history, :boolean, default: false, null: false
    end
  end
end