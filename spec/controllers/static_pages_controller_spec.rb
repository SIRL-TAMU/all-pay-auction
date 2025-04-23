# spec/controllers/static_pages_controller_spec.rb
require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #sell" do
    it "returns a successful response" do
      get :sell
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:sell)
    end
  end

  describe "GET #about" do
    it "returns a successful response" do
      get :about
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:about)
    end
  end
end
