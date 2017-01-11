require 'sidekiq/web'
require 'sidetiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root 'questions#index'

  concern :votable do
    member do
      post 'upvote'
      post 'downvote'
      delete 'unvote'
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions do
    concerns [:votable, :commentable]

    resources :answers, shallow: true, except: [:new, :show, :index] do
      concerns [:votable, :commentable]

      member do
        post 'mark_as_best'
      end
    end

    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'

  get 'terms' => 'pages#terms'
  get 'policy' => 'pages#policy'

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :list, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end

  resource :searches, only: [:show, :create]
end
