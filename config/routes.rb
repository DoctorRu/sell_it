Rails.application.routes.draw do

  post 'user_token' => 'user_token#create'

  get "ping", to: 'table_tennis#ping'

  resources :classifieds, only: [:index, :show, :create, :update, :destroy]
  resources :users, only: [:show]

end
