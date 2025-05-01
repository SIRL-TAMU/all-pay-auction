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
                             password: "password123#", # Meets requirements
                             password_confirmation: "password123#",
                             liquid_balance: 1000.00,
                             asset_balance: 1000.00
                           },
                           {
                             first_name: "Jane",
                             last_name: "Smith",
                             email: "buyer2@example.com",
                             password: "securepass456#", # Meets requirements
                             password_confirmation: "securepass456#",
                             liquid_balance: 1500.00,
                             asset_balance: 1500.00
                           },
                           {
                             first_name: "Bob",
                             last_name: "Boo",
                             email: "buyer3@example.com",
                             password: "testing123#", # Meets requirements
                             password_confirmation: "testing123#",
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
                               password: "sellerpass123#", # Meets requirements
                               password_confirmation: "sellerpass123#",
                               liquid_balance: 1000.00,
                               asset_balance: 1000.00
                             },
                             {
                               first_name: "Bob",
                               last_name: "Williams",
                               email: "seller2@example.com",
                               password: "bobspassword789#", # Meets requirements
                               password_confirmation: "bobspassword789#",
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
  [
    {
      buyer: buyers.first,
      auction_item: auction_items.first,
      amount: 550.00,
      created_at: Time.zone.now
    },
    {
      buyer: buyers.last,
      auction_item: auction_items.last,
      amount: 1100.00,
      created_at: Time.zone.now
    }
  ].each do |attrs|
    Bid.new(attrs).save(validate: false)
  end

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

  # Auction closing 1
  @seller = Seller.create!(
    first_name: "John",
    last_name: "Doe",
    email: "seller123@example.com",
    password: "password123#", # Meets requirements
    password_confirmation: "password123#",
    asset_balance: 1000.0,
    liquid_balance: 500.0
  )

  # Create a buyer
  @buyer = Buyer.create!(
    first_name: "Jane",
    last_name: "Doe",
    email: "buyer123@example.com",
    password: "password123#", # Meets requirements
    password_confirmation: "password123#",
    asset_balance: 1000.0,
    liquid_balance: 500.0
  )

  # Create an auction item with a closing date in the past
  @auction_item = AuctionItem.create!(
    seller: @seller,
    name: "Test Item",
    description: "Test Description",
    opening_date: Time.zone.now - 2.days, # Auction opened 2 days ago
    closing_date: Time.zone.now - 1.day,  # Auction closed 1 day ago
    innate_value: 100.0,
    min_increment: 10.0,
    is_archived: false,
    curr_max_bid: 0.0
  )

  # Create a bid for the auction item
  @bid = Bid.new(
    buyer: @buyer,
    auction_item: @auction_item,
    amount: 150.0,
    created_at: Time.zone.now - 1.day
  )
  @bid.save(validate: false)

  # Auction test 2
  # Create a seller
  @seller = Seller.create!(
    first_name: "John",
    last_name: "Doe",
    email: "seller1234@example.com",
    password: "password123#", # Meets requirements
    password_confirmation: "password123#",
    asset_balance: 1000.0,
    liquid_balance: 500.0
  )

  # Create buyers
  @buyer1 = Buyer.create!(
    first_name: "Buyer1",
    last_name: "Doe",
    email: "buyer1234@example.com",
    password: "password123#", # Meets requirements
    password_confirmation: "password123#",
    asset_balance: 1000.0,
    liquid_balance: 500.0
  )
  @buyer2 = Buyer.create!(
    first_name: "Buyer2",
    last_name: "Doe",
    email: "buyer2234@example.com",
    password: "password123#", # Meets requirements
    password_confirmation: "password123#",
    asset_balance: 1000.0,
    liquid_balance: 500.0
  )

  # Create auction items with closing dates in the past
  @auction_item1 = AuctionItem.create!(
    seller: @seller,
    name: "Item 1",
    description: "Description 1",
    opening_date: Time.zone.now - 2.days, # Auction opened 2 days ago
    closing_date: Time.zone.now - 1.day,  # Auction closed 1 day ago
    innate_value: 100.0,
    min_increment: 10.0,
    is_archived: false,
    curr_max_bid: 0.0
  )
  @auction_item2 = AuctionItem.create!(
    seller: @seller,
    name: "Item 2",
    description: "Description 2",
    opening_date: Time.zone.now - 2.days, # Auction opened 2 days ago
    closing_date: Time.zone.now - 1.day,  # Auction closed 1 day ago
    innate_value: 200.0,
    min_increment: 20.0,
    is_archived: false,
    curr_max_bid: 0.0
  )

  Bid.new(
    buyer: @buyer1,
    auction_item: @auction_item1,
    amount: 150.0,
    created_at: Time.zone.now - 1.day
  ).save(validate: false)

  Bid.new(
    buyer: @buyer2,
    auction_item: @auction_item2,
    amount: 250.0,
    created_at: Time.zone.now - 1.day
  ).save(validate: false)


  Rails.logger.debug do
    "Created #{Buyer.count} buyers, #{Seller.count} sellers, " \
      "#{AuctionItem.count} auction items, #{Bid.count} bids, " \
      "and #{Transaction.count} transactions!"
  end
end
