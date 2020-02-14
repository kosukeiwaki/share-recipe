Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "recipes#index"
  resources :recipes, only: [:index, :new, :create, :show] do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create]
  end
  resources :users, only: [:edit, :update]

end
