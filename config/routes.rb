# frozen_string_literal: true

Rails.application.routes.draw do
  # concern :reportable do
  #   resource :reports, except: %i[show], shallow: true
  # end

  resources :reports, except: %i[new create show index]

  resources :comments, except: %i[new create show index] do
    member do
      put 'like' => 'comments#vote'
    end
    resources :reports, only: %i[new create]
    resources :comments, only: %i[new create]
  end

  # concern :commentable do
  #   resource :comments, shallow: true do
  #     member do
  #       put 'like' => 'comments#vote'
  #     end
  #     concerns :reportable
  #   end
  # end

  # resources :comments, shallow: true, path: '/' do
  #   member do
  #     put 'like' => 'comments#vote'
  #   end
  #   concerns :commentable
  #   concerns :reportable
  # end

  get 'reports/index'
  get 'dashboard/index'
  get 'dashboard/user_report'
  get 'dashboard/user_suggestions'

  resources :posts do
    member do
      put 'like' => 'posts#vote'
      get 'new_suggestion' => 'comments#new_suggestion'
      get 'suggestions' => 'posts#suggestions'
    end
    resources :reports, only: %i[new create]
    resources :comments, only: %i[create]
    # concerns :reportable, :commentable
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
