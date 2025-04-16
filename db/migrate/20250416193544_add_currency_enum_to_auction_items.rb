class AddCurrencyEnumToAuctionItems < ActiveRecord::Migration[7.2]
  def change
    add_column :auction_items, :item_type, :integer, default: 0, null: false
  end
end
