Rails.application.routes.draw do
  get "user_sessions/new"
  get "user_sessions/create"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # products
  get "products" => "products#index"
  get "products/:id" => "products#show"
  get "products/:id/order" => "orders#new"
  post "products/:id/order" => "orders#create"

  # authentication
  get "/profile", to: "users#show"
  get "/", to: "home#index"
  get "register", to: "users#new"
  post "register", to: "users#register"
  get "login", to: "users#login"
  post "authenticate", to: "users#authenticate"
  post "logout", to: "users#logout"
  get "logout", to: "users#logout"

  # home
  get "/home", to: "users#home"

  # transactions
  get "/transactions", to: "transactions#index"
  get "/transactions/new", to: "transactions#new"
  post "/transactions", to: "transactions#create"
  post "/transactions/:id/delete", to: "transactions#destroy"

  # topup wallet
  get "/topup", to: "wallets#new"
  post "/topup", to: "wallets#topup"
  post "/generate-wallet", to: "wallets#create"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
