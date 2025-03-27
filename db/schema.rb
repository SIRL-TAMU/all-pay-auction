# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_03_27_072002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.decimal "asset_balance", null: false
    t.decimal "liquid_balance", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auction_items", force: :cascade do |t|
    t.bigint "seller_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "opening_date"
    t.datetime "closing_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "innate_value", null: false
    t.decimal "min_increment", null: false
    t.boolean "is_archived", default: false, null: false
    t.decimal "curr_max_bid", null: false
    t.bigint "winning_buyer_id"
    t.index ["seller_id"], name: "index_auction_items_on_seller_id"
  end

  create_table "bids", force: :cascade do |t|
    t.bigint "buyer_id", null: false
    t.bigint "auction_item_id", null: false
    t.decimal "amount"
    t.datetime "created_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_item_id"], name: "index_bids_on_auction_item_id"
    t.index ["buyer_id"], name: "index_bids_on_buyer_id"
  end

  create_table "buyers", force: :cascade do |t|
    t.string "first_name", limit: 64, null: false
    t.string "last_name", limit: 64, null: false
    t.string "email", limit: 128, null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "asset_balance", default: "0.0", null: false
    t.decimal "liquid_balance", default: "0.0", null: false
    t.string "provider"
    t.string "uid"
    t.boolean "verified", default: false
    t.string "verification_token"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "stripe_account_id"
    t.index ["email"], name: "index_buyers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_buyers_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_buyers_on_uid_and_provider", unique: true, where: "(uid IS NOT NULL)"
  end

  create_table "sellers", force: :cascade do |t|
    t.string "first_name", limit: 64, null: false
    t.string "last_name", limit: 64, null: false
    t.string "email", limit: 128, null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "asset_balance", default: "0.0", null: false
    t.decimal "liquid_balance", default: "0.0", null: false
    t.string "provider"
    t.string "uid"
    t.boolean "verified", default: false
    t.string "verification_token"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "stripe_account_id"
    t.index ["email"], name: "index_sellers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_sellers_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_sellers_on_uid_and_provider", unique: true, where: "(uid IS NOT NULL)"
  end

  create_table "stripe_transactions", force: :cascade do |t|
    t.bigint "buyer_id"
    t.bigint "seller_id"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "transaction_type", null: false
    t.string "stripe_transaction_id"
    t.datetime "transaction_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_stripe_transactions_on_buyer_id"
    t.index ["seller_id"], name: "index_stripe_transactions_on_seller_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "buyer_id", null: false
    t.bigint "seller_id", null: false
    t.decimal "amount"
    t.boolean "is_credit", default: false, null: false
    t.boolean "is_buyer", default: false, null: false
    t.datetime "created_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_transactions_on_buyer_id"
    t.index ["seller_id"], name: "index_transactions_on_seller_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "auction_items", "buyers", column: "winning_buyer_id"
  add_foreign_key "auction_items", "sellers"
  add_foreign_key "bids", "auction_items"
  add_foreign_key "bids", "buyers"
  add_foreign_key "stripe_transactions", "buyers"
  add_foreign_key "stripe_transactions", "sellers"
  add_foreign_key "transactions", "buyers"
  add_foreign_key "transactions", "sellers"
end
