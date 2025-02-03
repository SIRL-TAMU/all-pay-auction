# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data to avoid duplicates
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
sellers = Seller.create!([
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

puts "Created #{Buyer.count} buyers and #{Seller.count} sellers!"
