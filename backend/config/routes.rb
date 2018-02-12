Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :movies, only: [:index, :show]
      resources :users, only: [:index, :show]
      resources :directors, only: [:index, :show]
      post "/profile", to: "users#profile"
    end
  end
end
