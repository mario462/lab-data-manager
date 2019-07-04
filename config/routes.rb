Rails.application.routes.draw do
  resources :datasets, except: :index
  root to: 'home#index'
  get 'home/index'
  devise_for :users
  post 'studies/toggle_favorite/:id', to: 'studies#toggle_favorite', as: :toggle_favorite_study
  get 'studies/favorites', to: 'studies#favorites', as: :favorite_studies
  resources :studies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
