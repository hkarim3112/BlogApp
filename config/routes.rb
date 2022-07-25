# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'posts#index'
    end
    unauthenticated do
      root 'devise/sessions#new'
    end
  end

  resources :reports, only: %i[index edit update destroy]

  resources :comments, only: %i[edit update destroy] do
    member do
      put :like, to: 'comments#vote'
    end
    resources :reports, only: %i[new create]
    resources :comments, only: %i[new create]
  end

  resources :posts do
    member do
      put :like, to: 'posts#vote'
      get :new_suggestion, to: 'comments#new_suggestion'
      get :suggestions, to: 'posts#suggestions'
    end
    resources :reports, only: %i[new create]
    resources :comments, only: %i[create]
  end

  resources :dashboard, only: [:index]

  get :user_report, to: 'dashboard#user_report'
  get :user_suggestions, to: 'dashboard#user_suggestions'

  resources :moderators, only: [:index]

  get :publish, to: 'moderators#publish'
  get :unpublish, to: 'moderators#unpublish'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
