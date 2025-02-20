# frozen_string_literal: true

# Migration to add amount to seller table
class AddAmountToSellers < ActiveRecord::Migration[7.2]
  def change
    add_column :sellers, :amount, :decimal
  end
end
