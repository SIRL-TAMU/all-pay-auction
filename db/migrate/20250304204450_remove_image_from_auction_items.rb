# frozen_string_literal: true
# rubocop:disable all

# Migration to remove image column from auction_items table
class RemoveImageFromAuctionItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :auction_items, :image, :string
  end
end

# rubocop:enable all