require 'rails_helper'

RSpec.describe "SellerSettings", type: :request do
  describe "GET /edit" do
    it "returns http success" do
      get "/seller_settings/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/seller_settings/update"
      expect(response).to have_http_status(:success)
    end
  end
end
