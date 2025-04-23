# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuctionItem, type: :model do
  describe "validations" do
    let(:seller) { Seller.create(first_name: "Jane", last_name: "Doe", email: "seller1@gmail.com", password: "pass123#") }

    let(:valid_attributes) do
      {
        name: "Test Auction",
        opening_date: 1.day.ago,
        closing_date: 1.day.from_now,
        innate_value: 100,
        item_type: :physical,
        seller: seller
      }
    end

    it "is valid with valid attributes" do
      auction = AuctionItem.new(valid_attributes)
      expect(auction).to be_valid
    end

    it "is invalid without a seller" do
      auction = AuctionItem.new(valid_attributes.except(:seller))
      expect(auction).to_not be_valid
    end
  end

  describe "associations" do
    it "belongs to a seller" do
      association = AuctionItem.reflect_on_association(:seller)
      expect(association).to_not be_nil
      expect(association.macro).to eq(:belongs_to)
    end

    it "has many bids" do
      association = AuctionItem.reflect_on_association(:bids)
      expect(association).to_not be_nil
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "has many buyers through bids" do
      association = AuctionItem.reflect_on_association(:buyers)
      expect(association).to_not be_nil
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:bids)
    end
  end

  describe "custom methods" do
    let(:seller) { Seller.create(first_name: "Jane", last_name: "Doe", email: "seller2@gmail.com", password: "pass123#") }
    let(:buyer1) { Buyer.create(first_name: "John", last_name: "Doe", email: "buyer1@gmail.com", password: "test123#", liquid_balance: 100) }
    let(:buyer2) { Buyer.create(first_name: "Alice", last_name: "Smith", email: "buyer2@gmail.com", password: "test123#", liquid_balance: 200) }

    let(:auction) do
      AuctionItem.create(
        name: "Test Item",
        seller: seller,
        opening_date: 1.day.ago,
        closing_date: 1.day.from_now,
        innate_value: 100,
        item_type: :physical,
        min_increment: 10,
        curr_max_bid: 0
      )
    end

    it "#max_bid returns 0 when there are no bids" do
      expect(auction.max_bid).to eq(0)
    end

    it "#bid_pool sums highest bid per buyer" do
      Bid.create(auction_item: auction, buyer: buyer1, amount: 10)
      Bid.create(auction_item: auction, buyer: buyer1, amount: 20)
      Bid.create(auction_item: auction, buyer: buyer2, amount: 30)
      expect(auction.bid_pool).to eq(50)
    end

    it "#active? returns true between opening and closing dates" do
      expect(auction.active?).to be true
    end

    it "#closed? returns false if not yet closed" do
      expect(auction.closed?).to be false
    end

    it "#upcoming? returns false when already opened" do
      expect(auction.upcoming?).to be false
    end

    it "#archived? returns false if is_archived is false" do
      expect(auction.archived?).to be false
    end

    it "#status_text returns a string with 'Closing in'" do
      expect(auction.status_text).to include("Closing in")
    end

    it "#time_remaining returns a time string" do
      result = auction.time_remaining
      expect(result).to match(/\d+[dhm]/)
    end

    it "#total_bids counts all bids" do
      Bid.create!(auction_item: auction, buyer: buyer1, amount: 10)
      Bid.create!(auction_item: auction, buyer: buyer2, amount: 20)
      expect(auction.reload.total_bids).to eq(2)
    end

    it "#latest_bids returns the most recent bids" do
      Bid.create!(auction_item: auction, buyer: buyer1, amount: 10, created_at: 2.days.ago)
      Bid.create!(auction_item: auction, buyer: buyer2, amount: 20, created_at: 1.day.ago)
      latest = auction.latest_bids(1)
      expect(latest.length).to eq(1)
      expect(latest.first.amount).to eq(20)
    end

    it "#winning_bid returns the highest bid if auction is closed" do
      Bid.create!(auction_item: auction, buyer: buyer1, amount: 10)
      Bid.create!(auction_item: auction, buyer: buyer2, amount: 30)
      auction.update!(closing_date: 1.hour.ago) # simulate closed auction
      expect(auction.winning_bid.amount).to eq(30)
    end

    it "#close_auction! updates winning buyer and marks as archived" do
      buyer1.update!(asset_balance: 0, liquid_balance: 0)
      Bid.create!(auction_item: auction, buyer: buyer1, amount: 100)
      auction.update!(closing_date: 1.hour.ago)

      expect {
        auction.close_auction!
      }.to change { auction.reload.is_archived }.from(false).to(true)
    end

    it "writes auction names and time to test_cron.txt" do
      expect(File).to receive(:write).at_least(:once)
      AuctionItem.test_cron_job
    end
  end
end
