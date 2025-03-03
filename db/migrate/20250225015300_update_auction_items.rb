class UpdateAuctionItems < ActiveRecord::Migration[7.2]
  def change
    add_column :auction_items, :innate_value, :decimal, null: false 
    add_column :auction_items, :min_increment, :decimal, null: false
    add_column :auction_items, :is_archived, :boolean, default: false, null: false

    remove_column :auction_items, :max_bid
    add_column :auction_items, :curr_max_bid, :decimal, null: false
  end
end
