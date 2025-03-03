# frozen_string_literal: true
# rubocop:disable all

# This migration creates the buyers table in the database.
class CreateBuyers < ActiveRecord::Migration[7.2]
  def change
    create_table :buyers do |t|
      t.string :first_name, limit: 64, null: false
      t.string :last_name, limit: 64, null: false
      t.string :email, limit: 128, null: false
      t.string :password_digest, null: false

      # Optional: Add uniqueness constraint for email
      t.index :email, unique: true

      t.timestamps # Optional: Adds `created_at` and `updated_at` columns
    end
  end
end

# rubocop:enable all