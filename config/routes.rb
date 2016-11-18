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
    concerns :votable

    resources :answers, shallow: true, except: [:new, :show, :index] do
      member do
        post 'mark_as_best'
      end

      concerns :votable
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
