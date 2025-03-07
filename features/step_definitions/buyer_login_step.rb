# frozen_string_literal: true

Given('I am on the Buyer login page') do
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
