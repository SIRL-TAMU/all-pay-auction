# frozen_string_literal: true

Given("there is an auction item with bids and closing date has passed") do
  @auction_item = AuctionItem.joins(:bids)
                          .where(is_archived: false)
                          .where("closing_date < ?", Time.zone.now)
                          .distinct
                          .first
end

Given("the auction item is not archived or closed") do
  expect(@auction_item.is_archived).to be false
  expect(@auction_item.closed?).to be true # Ensure the auction is closed
end

When("I close the auction") do
  @auction_item.close_auction!
end

Then("the auction should be archived") do
  expect(@auction_item.reload.is_archived).to be true
end

Then("the winning buyer should be set") do
  @high_buyer = @auction_item.winning_bid.buyer
  expect(@auction_item.reload.winning_buyer_id).to eq(@high_buyer.id)
end

Given("there are multiple auction items with bids and closing date has passed") do
  @auction_items_with_bids = AuctionItem.joins(:bids)
                          .where(is_archived: false)
                          .where("closing_date < ?", Time.zone.now)
                          .distinct
                          .limit(2)
                          .to_a

  @auction_item1 = @auction_items_with_bids.at(0)
  @auction_item2 = @auction_items_with_bids.at(1)
end

Given("some auctions are not archived or closed") do
  expect(@auction_item1.is_archived).to be false
  expect(@auction_item2.is_archived).to be false
  expect(@auction_item1.closed?).to be true # Ensure the auction is closed
  expect(@auction_item2.closed?).to be true # Ensure the auction is closed
end

When("I run the cron job to close auctions") do
  AuctionItem.cron_close_auctions!
end

Then("all auctions should be archived") do
  expect(@auction_item1.reload.is_archived).to be true
  expect(@auction_item2.reload.is_archived).to be true
end

Then("the winning buyers should be set for each auction") do
  @high_buyer1 = @auction_item1.winning_bid.buyer
  @high_buyer2 = @auction_item2.winning_bid.buyer

  expect(@auction_item1.reload.winning_buyer_id).to eq(@high_buyer1.id)
  expect(@auction_item2.reload.winning_buyer_id).to eq(@high_buyer2.id)
end
