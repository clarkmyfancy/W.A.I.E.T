Rails.application.routes.draw do
<<<<<<< HEAD
  root 'home#index'
  
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
end
=======
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
>>>>>>> b339cc41de4cde6b61b1164bb97564f691fb6cc8
