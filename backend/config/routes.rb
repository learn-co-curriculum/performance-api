Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :movies, only: [:index, :show]
      resources :users, only: [:index, :show]
      resources :directors
    end
  end
end
