class SubscriptionsController < ApplicationController
  respond_to :json

  authorize_resource

  before_action :load_question, only: [:create]
  before_action :load_subscription, only: [:destroy]

  def create
    @subscription = @question.subscriptions.create(user: current_user)
    respond_with @subscription
  end

  def destroy
    respond_with(@subscription.destroy)
  end

  private

  def load_question
    @question = Question.find(params['question_id'])
  end

  def load_subscription
    @subscription = Subscription.find(params['id'])
  end
end
