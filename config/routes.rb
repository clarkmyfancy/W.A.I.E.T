Rails.application.routes.draw do
  # root 'home#index'
  get "/", to: "home#index", as: "root"
  
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'preferences/preferences', to: 'preferences#show', as: 'preferences'
end
