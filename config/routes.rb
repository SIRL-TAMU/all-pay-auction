# frozen_string_literal: true

Rails.application.routes.draw do
  get "seller_settings/edit"
  get "seller_settings/update"
  get "buyer_settings/edit"
  get "buyer_settings/update"
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

  # Buyer Settings
  get "/buyer/settings", to: "buyer_settings#edit", as: :buyer_setting
  patch "/buyer/settings", to: "buyer_settings#update", as: :update_profile_buyer_setting
  patch "/buyer/settings/password", to: "buyer_settings#update_password", as: :update_password_buyer_setting
  delete "/buyer/settings", to: "buyer_settings#destroy", as: :delete_buyer_setting

  # Seller Settings
  get "/seller/settings", to: "seller_settings#edit", as: :seller_setting
  patch "/seller/settings", to: "seller_settings#update", as: :update_profile_seller_setting
  patch "/seller/settings/password", to: "seller_settings#update_password", as: :update_password_seller_setting
  delete "/seller/settings", to: "seller_settings#destroy", as: :delete_seller_setting

  # Auction Items
  resources :auction_items do
    member do
      delete "remove_image/:image_id", to: "auction_items#remove_image", as: "remove_image"
    end
  end

  # Bids
  resources :bids, only: %i[create index show update] # update bid incase of repeat bids, CAN ONLY INCREASE.

  # Static Page
  get "/sell", to: "static_pages#sell"
  get "/about", to: "static_pages#about"
end
