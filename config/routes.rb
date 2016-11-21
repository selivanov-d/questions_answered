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
end
