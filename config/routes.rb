Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "products#index"
    
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users
    resources :products
    resources :orders, only: [:index, :destroy] do
      collection do
        get :failed
        get :succeeded
        get :confirming
      end
    end
  end
end