Rails.application.routes.draw do
  devise_for :users

  resources :groups do
    member do
      post :join
      post :quit
    end

    resources :posts do
      member do
        post :manage
      end
    end
  end

  namespace :account do
    resources :groups, only: [:index]
    resources :posts, only: [:index, :edit, :update, :destroy]
  end

  root "groups#index"
end
