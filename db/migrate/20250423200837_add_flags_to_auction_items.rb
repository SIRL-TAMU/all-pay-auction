class AddFlagsToAuctionItems < ActiveRecord::Migration[7.2]
  def change
    add_column :auction_items, :names_visible, :boolean, default: true, null: false
    add_column :auction_items, :bid_amount_visible, :boolean, default: true, null: false
  end
end
