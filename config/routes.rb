Rails.application.routes.draw do
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
      resources :questions, only: [:index, :show] do
        resources :answers, only: [:index, :show], shallow: true
      end
    end
  end
end
