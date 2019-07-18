Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'access_requests/new'
  get 'access_requests/create'
  resources :datasets, except: :index
  root to: 'home#index'
  get 'home/index'
  devise_for :users
  post 'studies/:id/add_member', to: 'studies#add_member', as: :add_member
  get 'studies/:id/members', to: 'studies#members', as: :study_members
  post 'studies/toggle_favorite/:id', to: 'studies#toggle_favorite', as: :toggle_favorite_study
  get 'studies/favorites', to: 'studies#favorites', as: :favorite_studies
  post 'studies/approve/:id', to: 'studies#approve', as: :approve_study
  get 'access_requests/outgoing', to: 'access_requests#outgoing', as: :outgoing_access_requests
  get 'access_requests/incoming', to: 'access_requests#incoming', as: :incoming_access_requests
  post 'access_requests/approve/:id', to: 'access_requests#approve', as: :approve_access_request
  post 'access_requests/deny/:id', to: 'access_requests#deny', as: :deny_access_request
  resources :studies
  resources :permissions, only: [:update, :destroy]
  resources :access_requests, only: [:new, :create]
  get 'datasets/download/:id', to: 'datasets#download', as: :download_dataset
  post 'datasets/approve/:id', to: 'datasets#approve', as: :approve_dataset
  get 'search', to: 'search#search', as: :search
  post 'search', to: 'search#search', as: :filter
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
