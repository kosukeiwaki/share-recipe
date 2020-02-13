Rails.application.routes.draw do
  devise_for :users
  get 'recipe/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "recipe#index"

end
