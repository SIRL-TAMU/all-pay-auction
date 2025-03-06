# frozen_string_literal: true

class RemoveImageFromAuctionItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :auction_items, :image, :string
  end
end
