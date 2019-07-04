Rails.application.routes.draw do

  devise_for :users
  root 'home#top'
  get "home/about" => "home#about"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users , only: [:show,:index,:edit,:update] do
  	member do
  		get :following
  		get :followers
  	end
  end
  resources :relationships, only: [:create, :destroy]

  resources :books do
  	resource :favorites, only: [:create, :destroy]
  	resources :book_comments, only: [:create, :edit, :update, :destroy]
  end

end
