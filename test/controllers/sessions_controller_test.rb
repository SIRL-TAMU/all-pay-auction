# frozen_string_literal: true

require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @buyer = buyers(:john) # Assumes fixtures are set up
    @seller = sellers(:alice)
  end

  test "should get new" do
    get login_path

    assert_response :success
  end

  test "should log in buyer with valid credentials" do
    post login_path, params: { account_type: "buyer", email: @buyer.email, password: "password123" }

    assert_equal session[:user_id], @buyer.id
    assert_equal "buyer", session[:account_type]
    assert_redirected_to buyer_dashboard_path
  end

  test "should log in seller with valid credentials" do
    post login_path, params: { account_type: "seller", email: @seller.email, password: "sellerpass123" }
    assert_equal session[:user_id], @seller.id
    assert_equal session[:account_type], "seller"
    assert_redirected_to seller_dashboard_path
  end

  test "should not log in with invalid credentials" do
    post login_path, params: { account_type: "buyer", email: @buyer.email, password: "wrongpassword" }
    assert_nil session[:user_id]
    assert_response :success
    assert_match I18n.t("errors.invalid_credentials"), @response.body

  end

  test "should not log in with non-existent user" do
    post login_path, params: { account_type: "buyer", email: "nonexistent@example.com", password: "password123" }
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
