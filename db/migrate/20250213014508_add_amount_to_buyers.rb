# frozen_string_literal: true

class AddAmountToBuyers < ActiveRecord::Migration[7.2]
  def change
    add_column :buyers, :amount, :decimal
  end
end
