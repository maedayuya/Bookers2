Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
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

  get "/search" => "books#search"
  
  post '/books/:book_id/favorites' => "favorites#create"
  delete '/books/:book_id/favorites' => "favorites#destroy"
  resources :books , only: [:index,:show,:create,:edit,:update,:destroy] do
  	resources :book_comments, only: [:create, :edit, :update, :destroy]
  end

end
