# frozen_string_literal: true

Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root path
  root "home#index"

  # Sessions user login/logout
  get "home/index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # User registration
  get "/signup", to: "registrations#new", as: :signup
  post "/signup", to: "registrations#create"

  # Buyer Dashboard
  get "/buyer/dashboard", to: "buyer_interface#index", as: :buyer_dashboard

  # Seller Dashboard
  get "/seller/dashboard", to: "seller_interface#index", as: :seller_dashboard

  # Manage Funds
  get "/manage_funds", to: "accounts#manage_funds", as: :manage_funds

  # Adding Funds
  post "/add_funds", to: "accounts#add_funds", as: :add_funds

  # Webhook for stripe transactions
  post "/stripe/webhook", to: "webhooks#stripe"

  # Auction Items
  resources :auction_items

  # Bids
  resources :bids, only: %i[create index show update] # update bid incase of repeat bids, CAN ONLY INCREASE.

  # Static Page
  get "/sell", to: "static_pages#sell"
  get "/about", to: "static_pages#about"
end
