# frozen_string_literal: true

require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    Buyer.destroy_all
    Seller.destroy_all

    @buyer = Buyer.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john@example.com",
      password: "password123#",
      password_confirmation: "password123#",
      verified: true
    )

    @seller = Seller.create!(
      first_name: "Alice",
      last_name: "Johnson",
      email: "seller1@example.com",
      password: "sellerpass123#",
      password_confirmation: "sellerpass123#",
      verified: true
    )
  end

  test "should get new" do
    get login_path

    assert_response :success
  end

  test "should log in buyer with valid credentials" do
    post login_path, params: { account_type: "buyer", email: @buyer.email, password: "password123#" }

    assert_equal @buyer.id, session[:user_id]
    assert_equal "buyer", session[:account_type]
    assert_redirected_to buyer_dashboard_path
  end

  test "should log in seller with valid credentials" do
    post login_path, params: { account_type: "seller", email: @seller.email, password: "sellerpass123#" }

    assert_equal @seller.id, session[:user_id]
    assert_equal "seller", session[:account_type]
    assert_redirected_to seller_dashboard_path
  end

  test "should not log in with invalid credentials" do
    post login_path, params: { account_type: "buyer", email: @buyer.email, password: "wrongpassword#" }

    assert_nil session[:user_id]
    assert_response :success
    assert_match I18n.t("errors.invalid_credentials"), @response.body
  end

  test "should not log in with non-existent user" do
    post login_path, params: { account_type: "buyer", email: "nonexistent@example.com", password: "password123#" }

    assert_nil session[:user_id]
    assert_response :success
  end

  test "should log out successfully" do
    delete logout_path

    assert_nil session[:user_id]
    assert_nil session[:account_type]
    assert_redirected_to root_path
  end
end
