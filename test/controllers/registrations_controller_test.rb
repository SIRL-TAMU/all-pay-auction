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
          password: "testpassword",
          password_confirmation: "testpassword"
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
          password: "testpassword",
          password_confirmation: "testpassword"
        }
      }
    end
    assert_redirected_to seller_dashboard_url
  end
end
