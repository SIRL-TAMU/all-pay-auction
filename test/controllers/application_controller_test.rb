# frozen_string_literal: true

require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
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

  test "buyer? returns true when session account type is buyer" do
    post login_path, params: {
      account_type: "buyer",
      email: @buyer.email,
      password: "password123#",
      verified: true
    }

    assert_equal "buyer", session[:account_type], "Session account_type not set correctly"
    get root_path

    assert_predicate @controller, :buyer?, "buyer? method returned false"
  end

  test "seller? returns true when session account type is seller" do
    post login_path, params: {
      account_type: "seller",
      email: @seller.email,
      password: "sellerpass123#"
    }

    assert_equal "seller", session[:account_type], "Session account_type not set correctly"
    get root_path

    assert_predicate @controller, :seller?, "seller? method returned false"
  end
    test "current_user returns buyer when session account type is buyer" do
        post login_path, params: {
          account_type: "buyer",
          email: @buyer.email,
          password: "password123#",
          verified: true
        }
        get root_path

        assert_equal @buyer, @controller.current_user, "current_user did not return the correct buyer"
    end
    test "current_user returns seller when session account type is seller" do
        post login_path, params: {
          account_type: "seller",
          email: @seller.email,
          password: "sellerpass123#"
        }
        get root_path

        assert_equal @seller, @controller.current_user, "current_user did not return the correct seller"
    end
      test "logged_in? returns true when user is logged in" do
        post login_path, params: {
          account_type: "buyer",
          email: @buyer.email,
          password: "password123#",
          verified: true
        }
        get root_path

        assert_predicate @controller, :logged_in?, "logged_in? returned false for a logged-in user"
      end

      test "logged_in? returns false when user is not logged in" do
        get root_path

        assert_not @controller.logged_in?, "logged_in? returned true for a non-logged-in user"
      end
end
