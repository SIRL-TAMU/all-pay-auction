# frozen_string_literal: true

class CreateBids < ActiveRecord::Migration[7.2]
  def change
    create_table :bids do |t|
      t.references :buyer, null: false, foreign_key: true
      t.references :auction_item, null: false, foreign_key: true
      t.decimal :amount
      t.datetime :created_date

      t.timestamps
    end
  end
end
