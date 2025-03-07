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

  get "/verify_email", to: "email_verifications#verify", as: :verify_user

  get "/password_resets/new", to: "password_resets#new", as: :new_password_reset
  post "/password_resets", to: "password_resets#create", as: :password_resets
  get "/password_resets/edit", to: "password_resets#edit", as: :edit_password_reset
  patch "/password_resets/update", to: "password_resets#update", as: :update_password_reset

  # Buyer Dashboard
  get "/buyer/dashboard", to: "buyer_interface#index", as: :buyer_dashboard

  # Seller Dashboard
  get "/seller/dashboard", to: "seller_interface#index", as: :seller_dashboard

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

  # Omniauth Routes
  get "/auth/:provider/callback", to: "sessions#omniauth"
  get "/auth/failure", to: redirect("/")

  post "/auth/google_oauth2_setup_login", to: "sessions#google_oauth2_setup_login", as: :google_oauth2_setup_login
  post "/auth/google_oauth2_setup_register", to: "sessions#google_oauth2_setup_register",
                                             as: :google_oauth2_setup_register
end
