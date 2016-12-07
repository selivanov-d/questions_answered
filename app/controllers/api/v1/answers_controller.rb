class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer

  before_action :load_question, only: [:index]
  before_action :load_answer, only: [:show]

  def index
    respond_with @question.answers, host: "#{request.protocol}#{request.host}"
  end

  def show
    respond_with @answer, host: "#{request.protocol}#{request.host}", serializer: SingleAnswerSerializer
  end

  protected

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
