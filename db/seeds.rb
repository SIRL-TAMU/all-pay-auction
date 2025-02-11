# frozen_string_literal: true

# Only run seed data in development
if Rails.env.development?
  # Clear existing data to avoid duplicates
  Buyer.destroy_all
  Seller.destroy_all

  # Passwords will automatically be hashed

  # Create sample buyers
  Buyer.create!([
                  {
                    first_name: "John",
                    last_name: "Doe",
                    email: "buyer1@example.com",
                    password: "password123",
                    password_confirmation: "password123"
                  },
                  {
                    first_name: "Jane",
                    last_name: "Smith",
                    email: "buyer2@example.com",
                    password: "securepass456",
                    password_confirmation: "securepass456"
                  }
                ])

  # Create sample sellers
  Seller.create!([
                   {
                     first_name: "Alice",
                     last_name: "Johnson",
                     email: "seller1@example.com",
                     password: "sellerpass123",
                     password_confirmation: "sellerpass123"
                   },
                   {
                     first_name: "Bob",
                     last_name: "Williams",
                     email: "seller2@example.com",
                     password: "bobspassword789",
                     password_confirmation: "bobspassword789"
                   }
                 ])

  Rails.logger.debug { "Created #{Buyer.count} buyers and #{Seller.count} sellers!" }
end
