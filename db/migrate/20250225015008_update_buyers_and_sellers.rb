# frozen_string_literal: true

# Migration update amount to asset_balance and liquid_balance for buyers and sellers
class UpdateBuyersAndSellers < ActiveRecord::Migration[7.2]
  def change
    # For Buyers
    remove_column :buyers, :amount
    add_column :buyers, :asset_balance, :decimal, null: false, default: 0.0
    add_column :buyers, :liquid_balance, :decimal, null: false, default: 0.0

    # For Sellers
    remove_column :sellers, :amount
    add_column :sellers, :asset_balance, :decimal, null: false, default: 0.0
    add_column :sellers, :liquid_balance, :decimal, null: false, default: 0.0
  end
end
