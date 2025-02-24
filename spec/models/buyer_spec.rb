# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Buyer, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      buyer = Buyer.new(first_name: "John",
                        last_name: "Doe",
                        email: "buyer1@gmail.com",
                        password: "test123",
                        amount: 0)
      expect(buyer).to be_valid
    end
    it "is invalid without an email" do
      buyer = Buyer.new(first_name: "John",
                        last_name: "Doe",
                        password: "test123",
                        amount: 0)
      expect(buyer).to_not be_valid
    end
    it "is invalid with duplicated email" do
      buyer1 = Buyer.create(first_name: "John",
                            last_name: "Doe",
                            email: "buyer1@gmail.com",
                            password: "test123",
                            amount: 0)

      buyer2 = Buyer.new(first_name: "Jane",
                         last_name: "Doe",
                         email: "buyer1@gmail.com",
                         password: "test123",
                         amount: 0)
      expect(buyer1).to be_valid
      expect(buyer2).to_not be_valid
    end
  end
end
