# frozen_string_literal: true

Given('I am on the Buyer login page') do
  Buyer.where(email: "buyer1@example.com").destroy_all
  @buyer = Buyer.create!(
    first_name: "John",
    last_name: "Doe",
    email: "buyer1@example.com",
    password: "password123#",
    password_confirmation: "password123#",
    verified: true
  )
  visit login_path
end

When('I fill in the Buyer login form with valid details') do
  # existing account
  fill_in 'email', with: 'buyer1@example.com'
  fill_in 'password', with: 'password123#'
end

When('I submit the Buyer login form') do
  click_button "Log in"
end

Then('I should be logged in and landed in the Buyer dashboard') do
  expect(current_path).to eq(buyer_dashboard_path)
end
