# frozen_string_literal: true

require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Ensure test database is clean before each test
    Buyer.destroy_all
    Seller.destroy_all
  end

  test "should create buyer" do
    assert_difference("Buyer.count", 1) do
      post signup_url(account_type: "buyer"), params: {
        user: {
          first_name: "Test",
          last_name: "Buyer",
          email: "testbuyer@example.com",
          password: "testpassword#",
          password_confirmation: "testpassword#"
        }
      }
    end
    assert_redirected_to buyer_dashboard_url
  end

  test "should create seller" do
    assert_difference("Seller.count", 1) do
      post signup_url(account_type: "seller"), params: {
        user: {
          first_name: "Test",
          last_name: "Seller",
          email: "testseller@example.com",
          password: "testpassword#",
          password_confirmation: "testpassword#"
        }
      }
    end
    assert_redirected_to seller_dashboard_url
  end

  test "should redirect to root path with invalid account type for new action" do
    get signup_url(account_type: "invalid")

    assert_redirected_to root_path
    assert_equal I18n.t("alerts.invalid_account_type"), flash[:alert]
  end

  test "should redirect to signup path with invalid account type for create action" do
    post signup_url(account_type: "invalid"), params: {
      user: {
        first_name: "Test2",
        last_name: "Seller2",
        email: "testseller2@example.com",
        password: "testpassword2",
        password_confirmation: "testpassword2"
      }
    }

    assert_redirected_to signup_path
    assert_equal I18n.t("alerts.invalid_account_type"), flash[:alert]
  end

  test "should render new with errors when create fails" do
    post signup_url(account_type: "buyer"), params: {
      user: {
        first_name: "",
        last_name: "",
        email: "invalid_email",
        password: "short",
        password_confirmation: "mismatch"
      }
    }

    assert_response :unprocessable_entity
    assert_not_empty flash[:alert] # display reason why account cannot be created
  end
end
