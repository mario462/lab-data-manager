Rails.application.routes.draw do
  resources :datasets, except: :index
  root to: 'home#index'
  get 'home/index'
  devise_for :users
  resources :studies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
