Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :votable do
    member do
      post 'upvote'
      post 'downvote'
      delete 'unvote'
    end
  end

  resources :questions do
    concerns [:votable]

    member do
      resource :comments, only: [:create]
    end

    resources :answers, shallow: true, except: [:new, :show, :index] do
      concerns [:votable]

      member do
        post 'mark_as_best'

        resource :comments, only: [:create]
      end
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
