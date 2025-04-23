# spec/controllers/accounts_controller_spec.rb
require 'rails_helper'
require 'ostruct'


RSpec.describe AccountsController, type: :controller do
  let(:buyer) do
    Buyer.create!(first_name: "John", last_name: "Doe", email: "buyer@example.com",
                  password: "test123#", liquid_balance: 100)
  end

  before { allow(controller).to receive(:current_user).and_return(buyer) }
  before { allow(controller).to receive(:logged_in?).and_return(true) }
  before { allow(controller).to receive(:buyer?).and_return(true) }

  describe "POST #add_funds" do
    it "redirects with error for non-positive amount" do
      post :add_funds, params: { amount: 0 }
      expect(flash[:alert]).to eq("Amount must be positive.")
      expect(response).to redirect_to(manage_funds_path)
    end
  end

  describe "GET #connect_stripe_account" do
    it "redirects to Stripe connect URL" do
      get :connect_stripe_account
      expect(response).to have_http_status(:redirect)
      expect(response.headers["Location"]).to include("https://connect.stripe.com/oauth/authorize")
    end
  end

  describe "GET #stripe_oauth_callback" do
    it "handles missing code param" do
      get :stripe_oauth_callback
      expect(flash[:alert]).to eq("No authorization code received.")
      expect(response).to redirect_to(manage_funds_path)
    end
  end

  describe "POST #withdraw_funds" do
    before { allow(buyer).to receive(:stripe_account_id).and_return("acct_12345") }
    before { allow(Stripe::Transfer).to receive(:create).and_return(OpenStruct.new(id: "tx_123")) }
    before { allow(buyer).to receive(:deduct_funds) }

    it "rejects negative withdrawal amount" do
      post :withdraw_funds, params: { amount: -5 }
      expect(flash[:alert]).to eq("Amount must be positive.")
    end

    it "rejects if user has insufficient balance" do
      post :withdraw_funds, params: { amount: 1000 }
      expect(flash[:alert]).to eq("Insufficient balance.")
    end
  end
end
