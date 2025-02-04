Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root path
  root "home#index"

  #Sessions user login/logout
  get "home/index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Buyer Dashboard
  get "/buyer/dashboard", to: "buyer_interface#index", as: :buyer_dashboard

  # Seller Dashboard
  get "/seller/dashboard", to: "seller_interface#index", as: :seller_dashboard
  
end
