Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :movies, only: [:index]
      resources :users, only: [:index]
    end
  end
end
