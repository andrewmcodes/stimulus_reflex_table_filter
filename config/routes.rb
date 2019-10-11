Rails.application.routes.draw do
  resources :restaurants
  root "restaurants#index"
end
