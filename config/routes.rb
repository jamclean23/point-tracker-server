Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "index/test_email", to: "index#testEmail"

  get "index/status", to: "index#status"

  get "index/get_sites", to: "index#getSites"

  post "index/get_points", to: "index#getPoints"

  post "auth/test_login", to: "auth#testLogin"

  get "auth/jwt_authenticate", to: "auth#jwtAuthenticate"

  post "auth/login", to: "auth#login"

  post "auth/create", to: "auth#create"

  delete "auth/delete", to: "auth#delete"

  get "auth/send_verification_email", to: "auth#sendVerificationEmail"

  get "auth/query_verified", to: "auth#queryVerified"

  get "auth/verify_email/*jwt", to: "auth#verifyEmail", constraints: { jwt: /.*/ }

  # Defines the root path route ("/")
  # root "posts#index"
end
