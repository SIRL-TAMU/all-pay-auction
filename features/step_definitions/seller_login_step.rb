# frozen_string_literal: true

Given('I am on the Seller login page') do
  Seller.where(email: "seller1@example.com").destroy_all
  @seller = Seller.create!(
    first_name: "Alice",
    last_name: "Johnson",
    email: "seller1@example.com",
    password: "sellerpass123#",
    password_confirmation: "sellerpass123#",
    verified: true
  )
  visit login_path(account_type: 'seller')
end

When('I fill in the Seller login form with valid details') do
  # existing account
  fill_in 'email', with: 'seller1@example.com'
  fill_in 'password', with: 'sellerpass123#'
end

When('I submit the Seller login form') do
  click_button "Log in"
end

Then('I should be logged in and landed in the Seller dashboard') do
  expect(current_path).to eq(seller_dashboard_path)
end
