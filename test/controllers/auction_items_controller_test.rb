# frozen_string_literal: true

require "test_helper"

class AuctionItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seller = sellers(:john)
    @auction_item = auction_items(:one)
    log_in_as_seller(@seller)
  end

  test "should get index" do
    get auction_items_path

    assert_response :success
  end

  test "should get show" do
    get auction_item_path(@auction_item)

    assert_response :success
  end

  test "should get new" do
    get new_auction_item_path

    assert_response :success
  end

  test "should create auction item" do
    post auction_items_path, params: {
      auction_item: {
        name: "Item",
        description: "Description",
        curr_max_bid: 100,
        min_increment: 5,
        innate_value: 500,
        opening_date: Time.zone.now,
        closing_date: 7.days.from_now
      }
    }

    assert_response :redirect
  end

  test "should get edit" do
    get edit_auction_item_path(@auction_item)

    assert_response :success
  end

  test "should update auction item" do
    patch auction_item_path(@auction_item), params: { auction_item: { name: "Updated Item" } }

    assert_response :redirect
  end

  test "should destroy auction item" do
    @auction_item = auction_items(:one)

    assert_difference("AuctionItem.count", -1) do
      delete auction_item_path(@auction_item), headers: { "HTTP_REFERER" => seller_dashboard_path }
    end

    assert_redirected_to seller_dashboard_path
  end
end
