# frozen_string_literal: true

Given('I am on the Seller registration page') do
  visit signup_path(account_type: 'seller')
  expect(current_path).to eq('/signup')
  expect(current_url).to eq('http://localhost:3000/signup?account_type=seller')
end

When('I fill in the Seller registration form with valid details') do
  test_prefix = "test_#{Time.now.to_i}"
  fill_in 'user_first_name', with: "#{test_prefix}_firstname"
  fill_in 'user_last_name', with: "#{test_prefix}_lastname"
  fill_in 'user_email', with: "#{test_prefix}_email@gmail.com"
  fill_in 'user_password', with: "test123"
  fill_in 'user_password_confirmation', with: "test123"
end

When('I submit the Seller registration form') do
  click_button "Continue"
end

Then('I should be logged in and redirected to the Seller dashboard') do
  expect(current_path).to eq(seller_dashboard_path)
end
