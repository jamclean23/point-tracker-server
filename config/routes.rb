Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  # ====== INDEX ======

  # Get

  get "index/status", to: "index#status"
  get "index/get_sites", to: "index#getSites"

  # Post

  post "index/test_email", to: "index#testEmail"
  post "index/get_points", to: "index#getPoints"


  # ====== AUTH ======

  # Get

  get "auth/jwt_authenticate", to: "auth#jwtAuthenticate"
  get "auth/send_verification_email", to: "auth#sendVerificationEmail"
  get "auth/query_verified", to: "auth#queryVerified"
  get "auth/verify_email/*jwt", to: "auth#verifyEmail", constraints: { jwt: /.*/ }
  get "auth/reset_password_page/*jwt", to: "auth#resetPasswordPage", constraints: { jwt: /.*/ }

  # Post

  post "auth/test_login", to: "auth#testLogin"
  post "auth/password_reset", to: "auth#passwordReset"
  post "auth/login", to: "auth#login"
  post "auth/create", to: "auth#create"
  post "auth/password_change", to: "auth#passwordChange"

  # Delete
  delete "auth/delete", to: "auth#delete"

end
