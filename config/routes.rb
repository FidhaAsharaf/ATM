Rails.application.routes.draw do
  root "sessions#new"

  post "/auth/:provider", to: "omniauth#passthru"
  get  "/auth/:provider/callback", to: "omniauth_callbacks#google"
  get  "/auth/failure", to: redirect("/login")


  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/welcome", to: "home#index"

  get "/balance", to: "home#balance"

  get  "/deposit", to: "home#deposit_form"
  post "/deposit", to: "home#deposit"

  get  "/withdraw", to: "home#withdraw_form"
  post "/withdraw", to: "home#withdraw"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  get "/transactions", to: "home#transactions_list"

  get  "/transfer", to: "home#transfer_form"
  post "/transfer", to: "home#transfer"
end
