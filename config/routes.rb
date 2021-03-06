Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # mount RuCaptcha::Engine => '/rucaptcha'
  root		'static_pages#home'
  get 		'/help',	to: 'static_pages#help'
  get 		'/about',	to: 'static_pages#about'
  get 		'/contact',	to: 'static_pages#contact'
  get 		'/signup',	to: 'users#new'
  post		'/signup',	to: 'users#create'
  get		'/login',	to: 'sessions#new'
  post		'/login',	to: 'sessions#create'
  delete	'/logout',	to: 'sessions#destroy'
  post		'/cars/new',	to: 'cars#create'
  resources :users
  resources :comments,		only: [:create, :destroy, :index]
  resources :cars,		only: [:new, :index, :show, :create, :edit, :update, :destroy]

end
