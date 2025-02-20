# frozen_string_literal: true

# Migration to create transactions table
class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :buyer, null: false, foreign_key: true
      t.references :seller, null: false, foreign_key: true
      t.decimal :amount
      t.boolean :is_credit, default: false, null: false
      t.boolean :is_buyer, default: false, null: false
      t.datetime :created_date

      t.timestamps
    end
  end
end
