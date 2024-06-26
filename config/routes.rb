Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "index/status", to: "index#status"

  get "index/get_sites", to: "index#getSites"

  post "auth/test_login", to: "auth#testLogin"

  get "auth/jwt_authenticate", to: "auth#jwtAuthenticate"

  post "auth/login", to: "auth#login"

  post "auth/create", to: "auth#create"

  delete "auth/delete", to: "auth#delete"

  # Defines the root path route ("/")
  # root "posts#index"
end
