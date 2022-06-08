# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts
  # root "posts#index"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root 'posts#index' # , as: :authenticated_root
    end
    unauthenticated do
      root 'devise/sessions#new' # , as: :unauthenticated_root
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
