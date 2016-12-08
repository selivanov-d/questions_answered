class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer

  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: [:show]

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def index
    respond_with @question.answers, host: "#{request.protocol}#{request.host}"
  end

  def show
    respond_with @answer, host: "#{request.protocol}#{request.host}", serializer: SingleAnswerSerializer
  end

  def create
    @answer = @question.answers.create(answer_params)
    respond_with @answer
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:content, :user_id, :question_id)
  end
end
