# frozen_string_literal: true

Rails.application.routes.draw do
  concern :reportable do
    resources :reports, except: [:show]
  end

  get 'reports/index'
  get 'dashboard/index'
  get 'dashboard/user_report'
  resources :posts do
    member do
      put 'like' => 'posts#vote'
    end
    concerns :reportable
  end
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  devise_scope :user do
    authenticated :user do
      # root 'dashboard#index'
      root 'posts#index' # , as: :authenticated_root
    end
    unauthenticated do
      root 'devise/sessions#new' # , as: :unauthenticated_root
    end
  end
  get '/moderator', to: 'moderators#index'
  get '/publish', to: 'moderators#publish'
  get '/unpublish', to: 'moderators#unpublish'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
