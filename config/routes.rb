Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "recipe#index"
  resources :recipes, only: [:index, :new]
  resources :users, only: [:edit, :update]

end
