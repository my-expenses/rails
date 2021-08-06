Rails.application.routes.draw do
  scope "/auth" do # to have /auth before the routes
    resources :transactions
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
