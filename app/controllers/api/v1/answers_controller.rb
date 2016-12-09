class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer

  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: [:show]

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }

  def index
    respond_with @question.answers, host: "#{request.protocol}#{request.host}"
  end

  def show
    respond_with @answer, host: "#{request.protocol}#{request.host}", serializer: SingleAnswerSerializer
  end

  def create
    @answer = @question.answers.create(answer_params)
    current_resource_owner.answers << @answer
    respond_with @answer
  end

  protected

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:content)
  end
end
