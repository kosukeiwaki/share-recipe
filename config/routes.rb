Rails.application.routes.draw do
  devise_for :users, controllers: {
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations'
}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "recipes#index"

  namespace :recipes do
    resources :searches, only: :index
  end

  resources :users, only: [:edit, :update, :destroy]
  resources :recipes do 
    collection do
      get 'random'
    end
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :show]
  end
  

end
