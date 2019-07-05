Rails.application.routes.draw do
  resources :datasets, except: :index
  root to: 'home#index'
  get 'home/index'
  devise_for :users
  post 'studies/:id/add_member', to: 'studies#add_member', as: :add_member
  get 'studies/:id/members', to: 'studies#members', as: :study_members
  post 'studies/toggle_favorite/:id', to: 'studies#toggle_favorite', as: :toggle_favorite_study
  get 'studies/favorites', to: 'studies#favorites', as: :favorite_studies
  resources :studies
  resources :permissions, only: [:update, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
