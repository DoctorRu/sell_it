Rails.application.routes.draw do

  post 'user_token' => 'user_token#create'

  get "ping", to: 'table_tennis#ping'

  concern :api_base do
    resources :classifieds, only: [:index, :show, :create, :update, :destroy]
    resources :users, only: [:show]
  end


  namespace :v1 do
    concerns :api_base
  end

  namespace :v2 do
    concerns :api_base
  end

end
