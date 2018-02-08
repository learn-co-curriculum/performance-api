Rails.application.routes.draw do
  resources :directors
  namespace :api do
    namespace :v1 do
      resources :movies, only: [:index, :show]
      resources :users, only: [:index, :show]
      post "/profile", to: "users#profile"
    end
  end
end
