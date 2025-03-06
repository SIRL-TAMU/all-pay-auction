# frozen_string_literal: true

# Only run seed data in development
if Rails.env.development?
  # Clear existing data to avoid duplicates
  Bid.destroy_all
  Transaction.destroy_all
  AuctionItem.destroy_all
  Buyer.destroy_all
  Seller.destroy_all

  # Passwords will automatically be hashed

  # Create sample buyers
  buyers = Buyer.create!([
                           {
                             first_name: "John",
                             last_name: "Doe",
                             email: "buyer1@example.com",
                             password: "password123",
                             password_confirmation: "password123",
                             liquid_balance: 1000.00,
                             asset_balance: 1000.00
                           },
                           {
                             first_name: "Jane",
                             last_name: "Smith",
                             email: "buyer2@example.com",
                             password: "securepass456",
                             password_confirmation: "securepass456",
                             liquid_balance: 1500.00,
                             asset_balance: 1500.00
                           },
                           {
                             first_name: "Bob",
                             last_name: "Boo",
                             email: "buyer3@example.com",
                             password: "testing",
                             password_confirmation: "testing",
                             liquid_balance: 150_000.00,
                             asset_balance: 150_000.00
                           }
                         ])

  # Create sample sellers
  sellers = Seller.create!([
                             {
                               first_name: "Alice",
                               last_name: "Johnson",
                               email: "seller1@example.com",
                               password: "sellerpass123",
                               password_confirmation: "sellerpass123",
                               liquid_balance: 1000.00,
                               asset_balance: 1000.00
                             },
                             {
                               first_name: "Bob",
                               last_name: "Williams",
                               email: "seller2@example.com",
                               password: "bobspassword789",
                               password_confirmation: "bobspassword789",
                               liquid_balance: 1500.00,
                               asset_balance: 1500.00
                             }
                           ])

  # Create sample auction items
  auction_items = AuctionItem.create!([
                                        {
                                          seller: sellers.first,
                                          name: "Antique Vase",
                                          description: "A beautiful antique vase from the 18th century.",
                                          curr_max_bid: 500.00,
                                          min_increment: 5.00,
                                          innate_value: 10_000.00,
                                          opening_date: Time.zone.now,
                                          closing_date: 7.days.from_now
                                        },
                                        {
                                          seller: sellers.last,
                                          name: "Vintage Watch",
                                          description: "A rare vintage watch in excellent condition.",
                                          curr_max_bid: 1000.00,
                                          innate_value: 50_000.00,
                                          min_increment: 10.00,
                                          opening_date: Time.zone.now,
                                          closing_date: 5.days.from_now
                                        }
                                      ])

  # Create sample bids
  Bid.create!([
                {
                  buyer: buyers.first,
                  auction_item: auction_items.first,
                  amount: 550.00,
                  created_date: Time.zone.now
                },
                {
                  buyer: buyers.last,
                  auction_item: auction_items.last,
                  amount: 1100.00,
                  created_date: Time.zone.now
                }
              ])

  # Create sample transactions
  Transaction.create!([
                        {
                          buyer: buyers.first,
                          seller: sellers.first,
                          amount: 550.00,
                          is_credit: true,
                          is_buyer: true,
                          created_date: Time.zone.now
                        },
                        {
                          buyer: buyers.last,
                          seller: sellers.last,
                          amount: 1100.00,
                          is_credit: true,
                          is_buyer: true,
                          created_date: Time.zone.now
                        }
                      ])
  Rails.logger.debug do
    "Created #{Buyer.count} buyers, #{Seller.count} sellers, " \
      "#{AuctionItem.count} auction items, #{Bid.count} bids, " \
      "and #{Transaction.count} transactions!"
  end
end
