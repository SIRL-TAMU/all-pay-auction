# frozen_string_literal: true

require "test_helper"

class AuctionItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get auction_items_index_url

    assert_response :success
  end

  test "should get show" do
    get auction_items_show_url

    assert_response :success
  end

  test "should get new" do
    get auction_items_new_url

    assert_response :success
  end

  test "should get create" do
    get auction_items_create_url

    assert_response :success
  end

  test "should get edit" do
    get auction_items_edit_url

    assert_response :success
  end

  test "should get update" do
    get auction_items_update_url

    assert_response :success
  end

  test "should get destroy" do
    get auction_items_destroy_url

    assert_response :success
  end
end
