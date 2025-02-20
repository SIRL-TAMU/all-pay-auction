# frozen_string_literal: true

# Migration to add amount to buyers table
class AddAmountToBuyers < ActiveRecord::Migration[7.2]
  def change
    add_column :buyers, :amount, :decimal
  end
end
