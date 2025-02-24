# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Buyer, type: :model do
  describe "validations" do
    let(:valid_attributes) do
      { first_name: "John", last_name: "Doe", email: "buyer1@gmail.com", password: "test123", amount: 0 }
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
end
