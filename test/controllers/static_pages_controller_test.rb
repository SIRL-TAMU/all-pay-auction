# frozen_string_literal: true

require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get sell" do
    get sell_url

    assert_response :success
  end

  test "should get about" do
    get about_url

    assert_response :success
  end
end
