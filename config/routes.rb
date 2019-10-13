Rails.application.routes.draw do
  resources :restaurants, only: :index
  root "restaurants#index"
end
