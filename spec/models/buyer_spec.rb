# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Buyer, type: :model do
  describe "validations" do
    let(:valid_attributes) do
      { first_name: "John", last_name: "Doe", email: "buyer1@gmail.com", password: "test123", liquid_balance: 0 }
    end

    it "is valid with valid attributes" do
      buyer = Buyer.new(valid_attributes)
      expect(buyer).to be_valid
    end

    it "is invalid without an email" do
      buyer = Buyer.new(valid_attributes.except(:email))
      expect(buyer).to_not be_valid
    end

    context "when email is duplicated" do
      before { Buyer.create!(valid_attributes) }

      it "is invalid with a duplicate email" do
        buyer2 = Buyer.new(valid_attributes.merge(first_name: "Jane"))
        expect(buyer2).to_not be_valid
      end
    end
  end

  describe "associations" do
    it "has many bids" do
      association = Buyer.reflect_on_association(:bids)
      expect(association).to_not be_nil
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
    it "has many transaction" do
      association = Buyer.reflect_on_association(:transactions)
      expect(association).to_not be_nil
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
    it "has many auction_items through bids" do
      association = Buyer.reflect_on_association(:auction_items)
      expect(association).to_not be_nil
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:bids)
    end
  end

  describe "custom methods" do
    describe "#sufficient_funds?" do
      it "returns true if buyer has sufficient funds" do
        buyer = Buyer.create(first_name: "John", last_name: "Doe", email: "buyer1@gmail.com", password: "test1",
                             liquid_balance: 100)
        auction_item = AuctionItem.create(name: "item1", curr_max_bid: "10", innate_value: 20)
        expect(buyer.sufficient_funds?(20, auction_item)).to be(true)
      end
      it "returns false if buyer does not have sufficient funds" do
        buyer = Buyer.create(first_name: "John", last_name: "Doe", email: "buyer1@gmail.com", password: "test1",
                             liquid_balance: 100)
        auction_item = AuctionItem.create(name: "item1", curr_max_bid: "100", innate_value: 120)
        expect(buyer.sufficient_funds?(120, auction_item)).to be(false)
      end
    end

    describe "#deduct_funds" do
      it "deduct funds from buyer account after places bid" do
        buyer = Buyer.create(first_name: "John", last_name: "Doe", email: "buyer1@gmail.com", password: "test1",
                             liquid_balance: 100)
        buyer.deduct_funds(10)
        expect(buyer.liquid_balance).to eq(90)
      end
    end
  end
end
