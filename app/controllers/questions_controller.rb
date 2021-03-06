class QuestionsController < ApplicationController
  respond_to :html, except: [:update]
  respond_to :json, only: [:update]

  skip_before_action :authenticate_user!, only: [:index, :show]

  authorize_resource
  skip_authorization_check only: [:index, :show]

  include Voted

  before_action :load_question, only: [:show, :destroy, :update]
  before_action :load_subscription, only: [:show]
  before_action :store_question_id_for_frontend, only: [:show]
  before_action :build_answer, only: [:show]
  before_action :build_comment, only: [:show]
  before_action :check_authorship, only: [:destroy, :update]

  def index
    respond_with(@questions = Question.all)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def new
    respond_with(@question = Question.new)
  end

  def show
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :content, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def load_subscription
    @subscription = Subscription.where(user: current_user, question: @question).first
  end

  def store_question_id_for_frontend
    gon.push({
      question_id: @question.id
    })
  end

  def build_answer
    @answer = Answer.new
  end

  def build_comment
    @comment = @question.comments.build
  end

  def check_authorship
    redirect_to @question, alert: 'Доступ запрещён!' unless current_user.author_of?(@question)
  end
end
