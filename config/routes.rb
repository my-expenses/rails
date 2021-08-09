Rails.application.routes.draw do
  scope "/auth" do # to have /auth before the routes
    resources :transactions
    resources :categories
  end

  scope "/users" do
    post "/login", to: "users#login"
    post "/register", to: "users#register"
    post "/refresh-token", to: "users#refresh_token"
    get "/status", to: "users#status"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
